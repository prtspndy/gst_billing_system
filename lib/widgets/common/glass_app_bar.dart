import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A reusable glassmorphic flexible space background widget that provides
/// a backdrop blur, translucent theme-aware surface, subtle border, and soft shadow.
class GlassFlexibleSpace extends StatelessWidget {
  final bool isBottom;
  final double? opacity;
  final double? blurSigma;

  const GlassFlexibleSpace({
    super.key,
    this.isBottom = false,
    this.opacity,
    this.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final darkAlpha = opacity ?? 0.65;
    final lightAlpha = opacity ?? 0.70;

    final bgColor = isDark
        ? AppMidnightColors.bg.withValues(alpha: darkAlpha)
        : Colors.white.withValues(alpha: lightAlpha);

    final borderColor = isDark
        ? AppMidnightColors.border.withValues(alpha: 0.60)
        : Colors.black.withValues(alpha: 0.07);

    final sigma = blurSigma ?? 16.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: isBottom
                ? Border(top: BorderSide(color: borderColor, width: 0.8))
                : Border(bottom: BorderSide(color: borderColor, width: 0.8)),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: isBottom ? const Offset(0, -3) : const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A drop-in replacement for standard AppBar that provides a transparent/glassmorphic aesthetic
/// with backdrop blur, translucent surface, and subtle border across Light and Dark themes.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final double? titleSpacing;

  const GlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.centerTitle = false,
    this.flexibleSpace,
    this.leadingWidth,
    this.titleSpacing,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: title,
      leading: leading,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      centerTitle: centerTitle,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: isDark ? Colors.white : const Color(0xFF1C1B1F),
      flexibleSpace: flexibleSpace ?? const GlassFlexibleSpace(),
    );
  }
}
