import 'package:flutter/material.dart';

/// Shared global header — ensures universal UI consistency.
/// Gradient (#1E5E2F -> #0F381B) is default while remaining theme-aware.
/// Usage: Scaffold(appBar: CustomAppHeader(title:'Study Planner', showBackButton:true))
class CustomAppHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.leadingIcon,
    this.useGradient = true,
    this.centerTitle = true,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final IconData? leadingIcon;
  final bool useGradient;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPop = Navigator.canPop(context);

    Widget? resolvedLeading;
    if (leading != null) {
      resolvedLeading = leading;
    } else if (showBackButton && canPop) {
      resolvedLeading = IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        tooltip: 'Back',
        onPressed: () => Navigator.maybePop(context),
      );
    }

    // Title widget — supports optional subtitle + leadingIcon (SPC Tutor case)
    Widget titleWidget;
    if (subtitle != null || leadingIcon != null) {
      titleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(leadingIcon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    }

    // Gradient path (default) — refined with subtle padding/typography
    if (useGradient) {
      return AppBar(
        elevation: 0,
        centerTitle: centerTitle,
        leading: resolvedLeading,
        title: titleWidget,
        titleSpacing: resolvedLeading == null ? 16 : 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E5E2F), Color(0xFF0F381B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: actions != null
            ? [...actions!, const SizedBox(width: 8)]
            : null,
      );
    }

    // Fallback: solid theme-aware (uses AppBarTheme)
    return AppBar(
      elevation: theme.appBarTheme.elevation ?? 0,
      centerTitle: centerTitle,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      leading: resolvedLeading == null
          ? null
          : (leading != null
              ? resolvedLeading
              : IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: theme.appBarTheme.foregroundColor),
                  onPressed: () => Navigator.maybePop(context),
                )),
      title: subtitle != null || leadingIcon != null
          ? titleWidget
          : Text(
              title,
              style: TextStyle(
                color: theme.appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
      actions: actions,
    );
  }
}
