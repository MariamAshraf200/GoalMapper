import 'package:flutter/material.dart';

class PlanDetailsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMore;

  const PlanDetailsHeader({
    super.key,
    required this.onBack,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(icon: Icons.arrow_back_ios_new, onTap: onBack),
          _circleButton(icon: Icons.more_horiz, onTap: onMore),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.black87),
        onPressed: onTap,
      ),
    );
  }
}

