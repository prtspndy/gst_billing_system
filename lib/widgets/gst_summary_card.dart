import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/number_to_words.dart';

class GstSummaryCard extends StatelessWidget {
  final double subtotal;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final double totalTax;
  final double grandTotal;
  final bool isInterState;

  const GstSummaryCard({
    super.key,
    required this.subtotal,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalIgst,
    required this.totalTax,
    required this.grandTotal,
    required this.isInterState,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : AppColors.secondaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? colorScheme.outline : AppColors.secondary.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST SUMMARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: isDark ? colorScheme.secondary : AppColors.secondaryDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isInterState ? AppColors.igstColor.withValues(alpha: 0.15) : AppColors.cgstColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInterState ? 'Inter-State (IGST)' : 'Intra-State (CGST + SGST)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isInterState ? AppColors.igstColor : AppColors.cgstColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRow('Taxable Subtotal', AppConstants.formatCurrency(subtotal), context),
          Divider(height: 16, color: colorScheme.outlineVariant),
          if (!isInterState) ...[
            _buildRow('Total CGST', AppConstants.formatCurrency(totalCgst), context, color: AppColors.cgstColor),
            const SizedBox(height: 4),
            _buildRow('Total SGST', AppConstants.formatCurrency(totalSgst), context, color: AppColors.sgstColor),
          ] else ...[
            _buildRow('Total IGST', AppConstants.formatCurrency(totalIgst), context, color: AppColors.igstColor),
          ],
          const SizedBox(height: 4),
          _buildRow('Total Tax', AppConstants.formatCurrency(totalTax), context, isBold: true),
          Divider(height: 20, thickness: 1.5, color: colorScheme.secondary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRAND TOTAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                AppConstants.formatCurrency(grandTotal),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          if (grandTotal > 0) ...[
            const SizedBox(height: 8),
            Text(
              NumberToWords.convert(grandTotal),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, BuildContext context, {bool isBold = false, Color? color}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: color ?? colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color ?? colorScheme.onSurface,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
