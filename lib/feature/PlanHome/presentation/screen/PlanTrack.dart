import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
import '../../../../core/util/custom_builders/navigate_to_screen.dart';
import 'addPlan.dart';

class PlanTrackerScreen extends StatefulWidget {
  const PlanTrackerScreen({super.key});

  @override
  State<PlanTrackerScreen> createState() => _PlanTrackerScreenState();
}

class _PlanTrackerScreenState extends State<PlanTrackerScreen> {
  String? selectedCategory;
  PlanStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    context.read<PlanBloc>().add(GetAllPlansEvent());
  }

  void _updateCategory(String? category) {
    setState(() => selectedCategory = category);
    if (category == null || category == "All") {
      context.read<PlanBloc>().add(GetAllPlansEvent());
    } else {
      context.read<PlanBloc>().add(GetPlansByCategoryEvent(category));
    }
  }

  void _updateStatus(PlanStatus? status) {
    setState(() => selectedStatus = status);
    if (status == null || status == PlanStatus.all) {
      context.read<PlanBloc>().add(GetAllPlansEvent());
    } else {
      context.read<PlanBloc>().add(GetPlansByStatusEvent(status.toPlanStatusString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCard(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.all(12),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // 🔹 Header
            _PlanHeader(
              onBack: () => Navigator.of(context).pop(),
              onAdd: () {
                navigateToScreenWithSlideTransition(
                  context,
                  const AddPlanScreen(),
                  // Optionally: beginOffset: Offset(1, 0),
                  // transitionDuration: Duration(milliseconds: 500),
                ).then((_) {
                  if (!mounted) return;
                  if (!context.mounted) return;
                });
              },
            ),
            const SizedBox(height: 12),

            // 🔹 Filters
            _PlanFilters(
              selectedCategory: selectedCategory,
              selectedStatus: selectedStatus,
              onCategoryChanged: _updateCategory,
              onStatusChanged: _updateStatus,
            ),
            const SizedBox(height: 16),

            // 🔹 Plan list
            const _PlanListSection(),
          ],
        ),
      ),
    );
  }
}

// ---------------- Header ----------------
class _PlanHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAdd;

  const _PlanHeader({required this.onBack, required this.onAdd});

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIconButton(icon: Icons.arrow_back_ios_new, onPressed: onBack),
          const Text(
            "My Plans",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _circleIconButton(icon: Icons.add, onPressed: onAdd),
        ],
      ),
    );
  }
}

// ---------------- Filters ----------------
class _PlanFilters extends StatelessWidget {
  final String? selectedCategory;
  final PlanStatus? selectedStatus;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<PlanStatus?> onStatusChanged;

  const _PlanFilters({
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              List<String> categories = ["All"];
              if (state is CategoryLoaded) {
                categories.addAll(state.categories.map((c) => c.categoryName));
              }
              return _FilterDropdown<String>(
                icon: const Icon(Icons.folder, color: Colors.deepPurple),
                value: selectedCategory,
                hint: "Select Category",
                items: [
                  ...categories.map(
                        (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  ),
                  const DropdownMenuItem(
                      value: null, child: Text("All Categories")),
                ],
                onChanged: onCategoryChanged,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FilterDropdown<PlanStatus>(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            value: selectedStatus,
            hint: "Select Status",
            items: PlanStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.toPlanStatusString()),
              );
            }).toList()
              ..insert(
                0,
                const DropdownMenuItem(
                  value: null,
                  child: Text("All Statuses"),
                ),
              ),
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final Widget icon;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(20), blurRadius: 5)],
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Plan List ----------------
class _PlanListSection extends StatelessWidget {
  const _PlanListSection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlanBloc, PlanState>(
        builder: (context, state) {
          if (state is PlanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlanLoaded) {
            if (state.plans.isEmpty) {
              return const Center(
                child: Text(
                  "No plans match the filters.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: state.plans.length,
              itemBuilder: (context, index) {
                return PlanItemCard(
                  plan: state.plans[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlanDetailsScreen(plan: state.plans[index]),
                      ),
                    ).then((_) {
                      // ✅ بعد الرجوع اعمل refresh
                      if (!context.mounted) return;
                      context.read<PlanBloc>().add(GetAllPlansEvent());
                    });
                  },
                );
              },
            );
          } else if (state is PlanError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
