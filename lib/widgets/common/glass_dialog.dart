import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A modern, premium glassmorphic replacement for [AlertDialog].
///
/// Features backdrop blur, theme-aware translucent surface, subtle borders,
/// soft ambient elevation/shadows, and high-contrast typography across
/// Light, Dark, and System themes.
class GlassAlertDialog extends StatelessWidget {
  final Widget? icon;
  final EdgeInsetsGeometry? iconPadding;
  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget? content;
  final EdgeInsetsGeometry? contentPadding;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final bool scrollable;
  final double? maxWidth;

  const GlassAlertDialog({
    super.key,
    this.icon,
    this.iconPadding,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding,
    this.actions,
    this.actionsPadding,
    this.actionsAlignment,
    this.scrollable = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? AppMidnightColors.card.withValues(alpha: 0.84)
        : Colors.white.withValues(alpha: 0.86);

    final borderColor = isDark
        ? AppMidnightColors.border.withValues(alpha: 0.85)
        : Colors.black.withValues(alpha: 0.08);

    final titleColor = isDark ? Colors.white : const Color(0xFF1C1B1F);
    final contentColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4A5568);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final resolvedMaxWidth = maxWidth ?? (screenWidth >= 600 ? 480.0 : 420.0);

    Widget dialogContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (icon != null) ...[
          Padding(
            padding: iconPadding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: icon!,
          ),
        ],
        if (title != null) ...[
          Padding(
            padding: titlePadding ??
                EdgeInsets.fromLTRB(24, icon != null ? 12 : 24, 24, 12),
            child: DefaultTextStyle(
              style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: 19,
                  ) ??
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: 19,
                  ),
              child: title!,
            ),
          ),
        ],
        if (content != null) ...[
          Padding(
            padding: contentPadding ??
                EdgeInsets.fromLTRB(
                  24,
                  title != null ? 0 : 20,
                  24,
                  actions != null && actions!.isNotEmpty ? 16 : 24,
                ),
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: contentColor,
                    fontSize: 14,
                    height: 1.45,
                  ) ??
                  TextStyle(
                    color: contentColor,
                    fontSize: 14,
                    height: 1.45,
                  ),
              child: content!,
            ),
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[
          Padding(
            padding: actionsPadding ??
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: actionsAlignment ?? MainAxisAlignment.end,
              children: actions!.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: action,
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );

    if (scrollable) {
      dialogContent = SingleChildScrollView(
        child: dialogContent,
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.45)
                        : Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: dialogContent,
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper to show a modal bottom sheet with a glassy frosted surface.
Future<T?> showGlassModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final bgColor = isDark
      ? AppMidnightColors.card.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.88);

  final borderColor = isDark
      ? AppMidnightColors.border.withValues(alpha: 0.85)
      : Colors.black.withValues(alpha: 0.08);

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    builder: (ctx) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: builder(ctx),
          ),
        ),
      );
    },
  );
}
