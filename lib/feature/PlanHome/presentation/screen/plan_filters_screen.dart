import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
import '../../domain/entities/plan_enums.dart';

class PlanFiltersScreen extends StatefulWidget {
  final String? initialCategory;
  final PlanStatus? initialStatus;

  const PlanFiltersScreen(
      {super.key, this.initialCategory, this.initialStatus});

  @override
  State<PlanFiltersScreen> createState() => _PlanFiltersScreenState();
}

class _PlanFiltersScreenState extends State<PlanFiltersScreen> {
  String? selectedCategory;
  PlanStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    selectedStatus = widget.initialStatus;
    // ensure categories are loaded
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                List<String> categories = ['All'];
                if (state is CategoryLoaded) {
                  categories
                      .addAll(state.categories.map((c) => c.categoryName));
                }
                return DropdownButtonFormField<String?>(
                  value: selectedCategory,
                  items: [
                    ...categories.map((c) => DropdownMenuItem(
                        value: c == 'All' ? null : c, child: Text(c)))
                  ],
                  onChanged: (v) => setState(() => selectedCategory = v),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<PlanStatus?>(
              value: selectedStatus,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...PlanStatus.values.where((p) => p != PlanStatus.all).map(
                    (p) => DropdownMenuItem(
                        value: p, child: Text(p.toPlanStatusString()))),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'category': selectedCategory,
                    'status': selectedStatus,
                  });
                },
                child: const Text('Apply Filters'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
