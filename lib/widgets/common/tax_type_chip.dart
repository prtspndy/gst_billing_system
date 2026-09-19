import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TaxTypeChip extends StatelessWidget {
  final bool isInterState;
  final bool isCompact;

  const TaxTypeChip({
    super.key,
    required this.isInterState,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final taxColors = context.taxColors;
    final color = isInterState ? taxColors.igst : taxColors.cgst;

    final label = isCompact
        ? (isInterState ? 'IGST' : 'CGST+SGST')
        : (isInterState ? 'Inter-State (IGST)' : 'Intra-State (CGST + SGST)');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isCompact ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
