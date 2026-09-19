import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../utils/constants.dart';
import '../utils/number_to_words.dart';
import 'common/tax_type_chip.dart';

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
    final taxColors = context.taxColors;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? colorScheme.outline
              : colorScheme.secondary.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: AppShadows.level1(isDark),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GST SUMMARY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              TaxTypeChip(isInterState: isInterState, isCompact: true),
            ],
          ),
          const SizedBox(height: 14),
          _buildRow('Taxable Subtotal', AppConstants.formatCurrency(subtotal), context),
          Divider(height: 20, color: colorScheme.outlineVariant),
          if (!isInterState) ...[
            _buildRow(
              'Total CGST',
              AppConstants.formatCurrency(totalCgst),
              context,
              color: taxColors.cgst,
            ),
            const SizedBox(height: 6),
            _buildRow(
              'Total SGST',
              AppConstants.formatCurrency(totalSgst),
              context,
              color: taxColors.sgst,
            ),
          ] else ...[
            _buildRow(
              'Total IGST',
              AppConstants.formatCurrency(totalIgst),
              context,
              color: taxColors.igst,
            ),
          ],
          const SizedBox(height: 6),
          _buildRow(
            'Total Tax Amount',
            AppConstants.formatCurrency(totalTax),
            context,
            isBold: true,
          ),
          Divider(
            height: 24,
            thickness: 1.5,
            color: colorScheme.primary.withValues(alpha: 0.3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRAND TOTAL',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                AppConstants.formatCurrency(grandTotal),
                style: TextStyle(
                  fontSize: 22,
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

  Widget _buildRow(
    String title,
    String value,
    BuildContext context, {
    bool isBold = false,
    Color? color,
  }) {
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
