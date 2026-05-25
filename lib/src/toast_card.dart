import 'package:flutter/material.dart';

/// A rich toast card widget for use inside [DelightToastBar].
///
/// Example:
/// ```dart
/// ToastCard(
///   title: const Text('Upload complete'),
///   subtitle: const Text('Your file was saved.'),
///   leading: const Icon(Icons.check_circle, color: Colors.green),
/// )
/// ```
class ToastCard extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? shadowColor;
  final VoidCallback? onTap;

  const ToastCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.color,
    this.shadowColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).dialogBackgroundColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 4),
            color: shadowColor ?? bg.withValues(alpha: 0.35),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: leading != null
            ? Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: leading)
            : null,
        trailing: trailing,
        subtitle: subtitle,
        title: title,
        onTap: onTap,
      ),
    );
  }
}
