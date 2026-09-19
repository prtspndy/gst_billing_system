import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../models/bill_item.dart';
import '../utils/constants.dart';

class BillItemTile extends StatelessWidget {
  final BillItem item;
  final bool isInterState;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;
  final bool isEditable;

  const BillItemTile({
    super.key,
    required this.item,
    required this.isInterState,
    this.onRemove,
    this.onQuantityChanged,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taxColors = context.taxColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline),
        boxShadow: AppShadows.level1(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (item.hsnCode != null && item.hsnCode!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'HSN: ${item.hsnCode}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isEditable && onRemove != null)
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: colorScheme.error,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onRemove,
                  tooltip: 'Remove Item',
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Rate: ${AppConstants.formatCurrency(item.rate)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'GST: ${AppConstants.formatGstRate(item.gstPercent)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Applicable Tax Breakdown (Only applicable taxes shown)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Taxable Amount',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppConstants.formatCurrency(item.taxableAmount),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (!isInterState) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'CGST (${(item.gstPercent / 2).toStringAsFixed(item.gstPercent % 2 == 0 ? 0 : 1)}%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: taxColors.cgst,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.formatCurrency(item.cgst),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: taxColors.cgst,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'SGST (${(item.gstPercent / 2).toStringAsFixed(item.gstPercent % 2 == 0 ? 0 : 1)}%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: taxColors.sgst,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.formatCurrency(item.sgst),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: taxColors.sgst,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'IGST (${item.gstPercent.toStringAsFixed(item.gstPercent % 1 == 0 ? 0 : 1)}%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: taxColors.igst,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.formatCurrency(item.igst),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: taxColors.igst,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isEditable && onQuantityChanged != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Qty: ',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      visualDensity: VisualDensity.compact,
                      onPressed: item.qty > 1 ? () => onQuantityChanged!(item.qty - 1) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '${item.qty}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onQuantityChanged!(item.qty + 1),
                    ),
                  ],
                )
              else
                Text(
                  'Qty: ${item.qty}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Line Total',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppConstants.formatCurrency(item.lineTotal),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
