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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).dialogBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 3,
            color: shadowColor ?? Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(7),
        leading: leading != null
            ? Padding(padding: const EdgeInsets.all(10), child: leading)
            : null,
        trailing: trailing,
        subtitle: subtitle,
        title: title,
        onTap: onTap,
      ),
    );
  }
}
