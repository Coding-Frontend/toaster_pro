import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'enums.dart';

class RawDelightToast extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Duration snackbarDuration;
  final Curve? animationCurve;
  final bool autoDismiss;
  final DelightSnackbarPosition snackbarPosition;
  final double Function() getScaleFactor;
  final double Function() getPosition;
  final VoidCallback onRemove;

  const RawDelightToast({
    super.key,
    required this.child,
    required this.animationDuration,
    required this.snackbarPosition,
    required this.snackbarDuration,
    required this.onRemove,
    required this.getPosition,
    required this.getScaleFactor,
    this.autoDismiss = true,
    this.animationCurve,
  });

  @override
  State<RawDelightToast> createState() => RawDelightToastState();
}

class RawDelightToastState extends State<RawDelightToast> {
  Widget _buildAnimated(Widget child) {
    return Animate(
      onComplete: (controller) {
        if (widget.autoDismiss) widget.onRemove();
      },
      effects: [
        SlideEffect(
          begin: Offset(
            0,
            widget.snackbarPosition == DelightSnackbarPosition.bottom ? 2 : -2,
          ),
          end: Offset.zero,
          duration: Duration(milliseconds: 2 * widget.animationDuration.inMilliseconds),
          curve: widget.animationCurve ?? Curves.elasticOut,
        ),
        FadeEffect(
          duration: widget.animationDuration,
          begin: 0,
          end: 1,
        ),
        if (widget.autoDismiss)
          SlideEffect(
            delay: widget.snackbarDuration,
            duration: const Duration(milliseconds: 500),
            curve: widget.animationCurve ?? Curves.easeInOut,
            begin: Offset.zero,
            end: const Offset(-1, 0),
          ),
      ],
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (_) => widget.onRemove(),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.animationDuration,
      curve: Curves.easeOutBack,
      top: widget.snackbarPosition == DelightSnackbarPosition.top
          ? widget.getPosition() + 70
          : null,
      bottom: widget.snackbarPosition == DelightSnackbarPosition.bottom
          ? widget.getPosition() + 70
          : null,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedScale(
          duration: widget.animationDuration,
          curve: Curves.bounceOut,
          scale: widget.getPosition() == 0 ? 1 : widget.getScaleFactor(),
          child: _buildAnimated(widget.child),
        ),
      ),
    );
  }
}
