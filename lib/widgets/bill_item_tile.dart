import 'package:flutter/material.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (item.hsnCode != null && item.hsnCode!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'HSN: ${item.hsnCode}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isEditable && onRemove != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.error),
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
              Text(
                'Rate: ${AppConstants.formatCurrency(item.rate)}',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'GST: ${item.gstPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isEditable && onQuantityChanged != null)
                Row(
                  children: [
                    const Text('Qty: ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 22, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: item.qty > 1 ? () => onQuantityChanged!(item.qty - 1) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.qty}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 22, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onQuantityChanged!(item.qty + 1),
                    ),
                  ],
                )
              else
                Text(
                  'Qty: ${item.qty}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tax: ${AppConstants.formatCurrency(item.totalTax)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isInterState ? AppColors.igstColor : AppColors.cgstColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    AppConstants.formatCurrency(item.lineTotal),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
