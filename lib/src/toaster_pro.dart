import 'package:flutter/material.dart';
import 'delight_toast.dart';
import 'enums.dart';
import 'toast_card.dart';

/// High-level convenience API for showing toasts from anywhere in the app.
///
/// **Setup** — call once in your app entry point:
/// ```dart
/// ToasterPro.navigatorKey = Get.key; // or any GlobalKey<NavigatorState>
/// ```
///
/// **Usage:**
/// ```dart
/// ToasterPro.show(title: 'Saved!', message: 'Your changes were saved.');
/// ToasterPro.show(title: 'Error', message: 'Something went wrong.', type: ToastType.error);
/// ```
class ToasterPro {
  ToasterPro._();

  /// Set this to your app's navigator key so toasts work without a BuildContext.
  /// For GetX apps: `ToasterPro.navigatorKey = Get.key;`
  static set navigatorKey(GlobalKey<NavigatorState>? key) {
    DelightToastBar.navigatorKey = key;
  }

  static final Map<ToastType, Color> _typeColors = {
    ToastType.success: const Color(0xFF4CAF50),
    ToastType.error:   const Color(0xFFE8505B),
    ToastType.warning: const Color(0xFFFF9800),
    ToastType.info:    const Color(0xFF2196F3),
  };

  static final Map<ToastType, IconData> _typeIcons = {
    ToastType.success: Icons.check_circle_rounded,
    ToastType.error:   Icons.error_rounded,
    ToastType.warning: Icons.warning_rounded,
    ToastType.info:    Icons.info_rounded,
  };

  /// Show a styled toast notification.
  ///
  /// [type] controls the accent colour and icon.
  /// [backgroundColor] overrides the card background.
  /// [onTap] is called when the user taps the toast.
  /// [context] is optional — if not provided, [navigatorKey] is used.
  static void show({
    required String title,
    String? message,
    ToastType type = ToastType.info,
    Color? backgroundColor,
    VoidCallback? onTap,
    Duration duration = const Duration(milliseconds: 3500),
    DelightSnackbarPosition position = DelightSnackbarPosition.bottom,
    BuildContext? context,
  }) {
    final accentColor = _typeColors[type]!;
    final iconData = _typeIcons[type]!;

    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: duration,
      position: position,
      builder: (ctx) => ToastCard(
        color: backgroundColor ?? const Color(0xFF1E1F25),
        shadowColor: accentColor.withValues(alpha: 0.18),
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: accentColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFDEE2F0),
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: message != null
            ? Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFB7BBC8),
                  fontFamily: 'Lato',
                  fontSize: 12,
                  height: 1.4,
                ),
              )
            : null,
      ),
    ).show(context);
  }

  /// Dismiss all currently visible toasts.
  static void dismissAll() => DelightToastBar.removeAll();
}
