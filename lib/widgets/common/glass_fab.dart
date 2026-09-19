import 'dart:ui';
import 'package:flutter/material.dart';

/// A modern, premium Material 3 Floating Action Button with Glassmorphism styling.
///
/// Features:
/// - Theme-aware translucent surface (Light, Dark, System)
/// - Backdrop blur effect with soft border and elevation
/// - High text & icon contrast
/// - Responsive support: extended (icon + label) or icon-only
class GlassFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Widget? label;
  final String? tooltip;
  final Object? heroTag;
  final bool isExtended;

  const GlassFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.tooltip,
    this.heroTag,
    this.isExtended = false,
  });

  const GlassFloatingActionButton.extended({
    super.key,
    required this.onPressed,
    required this.icon,
    required Widget this.label,
    this.tooltip,
    this.heroTag,
  }) : isExtended = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware glass colors
    final bgColor = isDark
        ? const Color(0xFF1E2638).withValues(alpha: 0.82)
        : colorScheme.primary.withValues(alpha: 0.88);

    final borderColor = isDark
        ? const Color(0xFF3F51B5).withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.35);

    final foregroundColor = isDark ? Colors.white : colorScheme.onPrimary;

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : colorScheme.primary.withValues(alpha: 0.30);

    final content = isExtended && label != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(color: foregroundColor, size: 22),
                child: icon,
              ),
              const SizedBox(width: 10),
              DefaultTextStyle(
                style: theme.textTheme.labelLarge?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ) ??
                    TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                child: label!,
              ),
            ],
          )
        : IconTheme(
            data: IconThemeData(color: foregroundColor, size: 24),
            child: icon,
          );

    final buttonWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(18),
              splashColor: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.20),
              highlightColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isExtended ? 20.0 : 16.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );

    final taggedButton = heroTag != null
        ? Hero(tag: heroTag!, child: buttonWidget)
        : buttonWidget;

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: taggedButton,
      );
    }

    return taggedButton;
  }
}
