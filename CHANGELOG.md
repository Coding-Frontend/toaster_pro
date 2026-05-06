## 1.0.0

- Initial release
- `ToasterPro.show()` convenience API — show typed toasts without a `BuildContext`
- `DelightToastBar` — low-level overlay-based toast with builder pattern
- `ToastCard` widget — pre-styled card with accent bar, leading icon, title, and subtitle
- `ToastType` presets: `success`, `error`, `warning`, `info` with default icons & colours
- `DelightSnackbarPosition.top` and `.bottom` support
- Stacking animation — multiple toasts scale and offset elegantly
- Slide + fade enter/exit animations powered by `flutter_animate`
- Auto-dismiss with configurable `Duration`
- Optional `onTap` callback per toast
- `DelightToastBar.removeAll()` to dismiss all active toasts at once
- Navigator key support — wire once, toast from anywhere (no context required)
- Works seamlessly with GetX (`Get.key`) and standard Flutter (`GlobalKey<NavigatorState>`)
