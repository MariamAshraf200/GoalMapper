import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/l10n/app_localizations.dart';
import '../../../../core/util/widgets/custom_dilog.dart';
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

class PlanImageSection extends StatelessWidget {
  final PlanDetails plan;

  const PlanImageSection({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Builder(builder: (ctx) {
              final imagePath = plan.image;
              if (imagePath == null || imagePath.trim().isEmpty) {
                return Row(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.image, size: 36, color: Colors.grey),
                    ),
                  ],
                );
              }


              final file = File(imagePath);
              final exists = file.existsSync();
              if (!exists) {
                return Row(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                    ),
                  ],
                );
              }

              // If file exists show thumbnail with an overlay 'X' button to remove
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => showDialog(
                          context: ctx,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: Image.file(
                                file,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Container(
                                  padding: const EdgeInsets.all(24),
                                  child: const Icon(Icons.broken_image, size: 56, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 120,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      // Positioned 'X' button
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close, size: 18, color: Colors.white),
                            splashRadius: 18,
                            onPressed: () async {
                              // confirm removal
                              final confirmed = await showDialog<bool?>(
                                context: ctx,
                                builder: (dctx) => CustomDialog(
                                  title: l10n.deletePlan,
                                  description: l10n.deletePlanDescription,
                                  operation: l10n.deleteOperation,
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onCanceled: () => Navigator.of(dctx).pop(false),
                                  onConfirmed: () => Navigator.of(dctx).pop(true),
                                ),
                              );

                              if (confirmed == true) {
                                final updated = plan.copyWith(image: null);
                                context.read<PlanBloc>().add(UpdatePlanEvent(updated));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
