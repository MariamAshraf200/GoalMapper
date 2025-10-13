import 'package:flutter/material.dart';
import 'package:mapperapp/core/util/widgets/loading_elevate_icon_button.dart';

class PlanDetailsBottomButton extends StatelessWidget {
  final VoidCallback onEdit;
  const PlanDetailsBottomButton({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: LoadingElevatedButton(
          onPressed: () async {
            onEdit();
          },
          buttonText: 'Edit Plan',
          icon: const Icon(Icons.edit),
          showLoading: true,
          // match previous styling
          verticalPadding: 14,
          borderRadius: 12.0,
        ),
      ),
    );
  }
}
