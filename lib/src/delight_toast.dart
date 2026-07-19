import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'enums.dart';
import 'raw_delight_toast.dart';

/// Global registry of active toast bars
final List<DelightToastBar> _toastBars = [];

/// The gap (pixels) between stacked toast cards
const int _gapBetweenCard = 15;

double _calculatePosition(List<DelightToastBar> bars, DelightToastBar self) {
  if (bars.isNotEmpty && self != bars.last) {
    final box =
        self._info?.key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return _gapBetweenCard *
          (bars.length - bars.indexOf(self) - 1).toDouble();
    }
  }
  return 0;
}

double _calculateScaleFactor(
    List<DelightToastBar> bars, DelightToastBar current) {
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
  bool _showScheduled = false;

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
  }) : assert(
            snackbarDuration.inMilliseconds > animationDuration.inMilliseconds);

  /// Remove this individual toast
  void remove() {
    final info = _info;
    if (info != null) {
      info.entry.remove();
    }
    _info = null;
    _toastBars.removeWhere((e) => e == this);
  }

  /// Show the toast. Optionally pass a [BuildContext]; otherwise the package
  /// uses [DelightToastBar.navigatorKey].
  void show([BuildContext? context]) {
    if (_info != null || _showScheduled) return;

    // Try to resolve a BuildContext first from the caller, then from the
    // configured navigatorKey. If an overlay is not yet available (app
    // still building), schedule a retry on the next frame so toasts work
    // reliably during startup without requiring callers to call setState.
    BuildContext? ctx = context ?? navigatorKey?.currentContext;

    OverlayState? overlay;
    if (ctx != null) {
      overlay = Navigator.of(ctx, rootNavigator: true).overlay;
    } else {
      overlay = navigatorKey?.currentState?.overlay;
    }

    if (overlay == null) {
      _showScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showScheduled = false;
        show(context);
      });
      SchedulerBinding.instance.ensureVisualUpdate();
      return;
    }

    final buildCtx = ctx ?? overlay.context;

    void insert() {
      if (_info != null) return;
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
          child: builder.call(buildCtx),
        ),
      );
      overlay!.insert(info.entry);
      _toastBars.add(this);
      SchedulerBinding.instance.ensureVisualUpdate();
    }

    // User actions normally arrive while the scheduler is idle, where an
    // immediate overlay insertion is safe and guarantees the toast appears.
    // During widget build, defer once and explicitly request the next frame.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      _showScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showScheduled = false;
        insert();
      });
      SchedulerBinding.instance.ensureVisualUpdate();
    } else {
      insert();
    }
  }

  /// Dismiss all active toasts
  static void removeAll() {
    for (final bar in List<DelightToastBar>.of(_toastBars)) {
      bar.remove();
    }
  }
}

class _SnackBarInfo {
  late final OverlayEntry entry;
  final GlobalKey<RawDelightToastState> key;

  _SnackBarInfo({required this.key});
}
