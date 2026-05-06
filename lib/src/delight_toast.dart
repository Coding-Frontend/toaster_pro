import 'package:flutter/material.dart';
import 'enums.dart';
import 'raw_delight_toast.dart';

/// Global registry of active toast bars
final List<DelightToastBar> _toastBars = [];

/// The gap (pixels) between stacked toast cards
const int _gapBetweenCard = 15;

double _calculatePosition(List<DelightToastBar> bars, DelightToastBar self) {
  if (bars.isNotEmpty && self != bars.last) {
    final box = self._info?.key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return _gapBetweenCard * (bars.length - bars.indexOf(self) - 1).toDouble();
    }
  }
  return 0;
}

double _calculateScaleFactor(List<DelightToastBar> bars, DelightToastBar current) {
  final index = bars.indexOf(current);
  final indexFromLast = bars.length - 1 - index;
  final factor = indexFromLast / 25;
  final result = 0.97 - factor;
  return result < 0 ? 0 : result;
}

/// Core class for showing overlay-based toast notifications.
///
/// ```dart
/// DelightToastBar(
///   autoDismiss: true,
///   builder: (context) => ToastCard(
///     title: const Text('Hello!'),
///   ),
/// ).show();
/// ```
class DelightToastBar {
  /// How long the toast stays visible (when [autoDismiss] is true)
  final Duration snackbarDuration;

  /// Position: top or bottom of the screen
  final DelightSnackbarPosition position;

  /// Auto-dismiss the toast after [snackbarDuration]
  final bool autoDismiss;

  /// Builder for the toast content widget
  final WidgetBuilder builder;

  /// Duration of entry/exit animations
  final Duration animationDuration;

  /// Animation curve
  final Curve? animationCurve;

  _SnackBarInfo? _info;

  /// An optional [NavigatorKey] to resolve the overlay. If null, the package
  /// will attempt to use the root navigator of the context provided to [show].
  static GlobalKey<NavigatorState>? navigatorKey;

  DelightToastBar({
    this.snackbarDuration = const Duration(milliseconds: 3500),
    this.position = DelightSnackbarPosition.bottom,
    required this.builder,
    this.animationDuration = const Duration(milliseconds: 700),
    this.autoDismiss = true,
    this.animationCurve,
  }) : assert(snackbarDuration.inMilliseconds > animationDuration.inMilliseconds);

  /// Remove this individual toast
  void remove() {
    _info?.entry.remove();
    _toastBars.removeWhere((e) => e == this);
  }

  /// Show the toast. Optionally pass a [BuildContext]; otherwise the package
  /// uses [DelightToastBar.navigatorKey].
  void show([BuildContext? context]) {
    BuildContext? ctx = context;
    if (ctx == null) {
      ctx = navigatorKey?.currentContext;
    }
    if (ctx == null) return;

    final overlay = Navigator.of(ctx, rootNavigator: true).overlay;
    if (overlay == null) return;

    final info = _SnackBarInfo(key: GlobalKey<RawDelightToastState>());
    _info = info;

    info.entry = OverlayEntry(
      builder: (_) => RawDelightToast(
        key: info.key,
        animationDuration: animationDuration,
        snackbarPosition: position,
        animationCurve: animationCurve,
        autoDismiss: autoDismiss,
        getPosition: () => _calculatePosition(_toastBars, this),
        getScaleFactor: () => _calculateScaleFactor(_toastBars, this),
        snackbarDuration: snackbarDuration,
        onRemove: remove,
        child: builder.call(ctx!),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toastBars.add(this);
      overlay.insert(info.entry);
    });
  }

  /// Dismiss all active toasts
  static void removeAll() {
    for (final bar in _toastBars) {
      bar._info?.entry.remove();
    }
    _toastBars.clear();
  }
}

class _SnackBarInfo {
  late final OverlayEntry entry;
  final GlobalKey<RawDelightToastState> key;

  _SnackBarInfo({required this.key});
}
