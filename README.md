# toaster_pro

[![pub package](https://img.shields.io/pub/v/toaster_pro.svg)](https://pub.dev/packages/toaster_pro)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A **premium overlay-based toast notification** package for Flutter.  
Supports stacking, smooth slide/fade animations, auto-dismiss, and four typed
presets — all without needing a `BuildContext` after initial setup.

---

## Features

- 🎨 **4 typed presets** — `success`, `error`, `warning`, `info` with matching icons & colours
- 🪄 **Smooth animations** — enter/exit slide + fade powered by `flutter_animate`
- 📦 **Stacking support** — multiple toasts stack and scale elegantly
- 🎯 **No `BuildContext` required** — wire a navigator key once, call `ToasterPro.show()` from anywhere
- 🔧 **Low-level API** — use `DelightToastBar` + `ToastCard` for fully custom toasts
- 📍 **Top or bottom** positioning
- ⏱️ **Configurable duration** and tap callbacks
- 🚫 **Dismiss all** with a single call

---

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  toaster_pro: ^1.0.0
```

### Wire the navigator key once

```dart
// Standard Flutter app
class MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToasterPro.navigatorKey = _navKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorKey: _navKey, ...);
  }
}

// GetX apps — even simpler:
ToasterPro.navigatorKey = Get.key;
```

---

## Usage

### Convenience API

```dart
import 'package:toaster_pro/toaster_pro.dart';

// Basic typed toasts
ToasterPro.show(title: 'Saved!',  message: 'Changes applied.',       type: ToastType.success);
ToasterPro.show(title: 'Error',   message: 'Something went wrong.',   type: ToastType.error);
ToasterPro.show(title: 'Warning', message: 'Session expires soon.',   type: ToastType.warning);
ToasterPro.show(title: 'Info',    message: 'New update available.',   type: ToastType.info);

// Top position
ToasterPro.show(
  title: 'Hey!',
  message: 'I appear at the top.',
  type: ToastType.info,
  position: DelightSnackbarPosition.top,
);

// With tap action
ToasterPro.show(
  title: 'New message',
  type: ToastType.info,
  onTap: () => Navigator.pushNamed(context, '/messages'),
);

// Custom duration
ToasterPro.show(
  title: 'Hold on',
  message: 'This stays for 8 seconds.',
  type: ToastType.warning,
  duration: const Duration(seconds: 8),
);

// Dismiss all active toasts
DelightToastBar.removeAll();
```

### Low-level API

```dart
DelightToastBar(
  autoDismiss: true,
  position: DelightSnackbarPosition.bottom,
  builder: (ctx) => ToastCard(
    color: Colors.black87,
    leading: const Icon(Icons.rocket_launch, color: Colors.white),
    title: const Text('Custom Toast', style: TextStyle(color: Colors.white)),
    subtitle: const Text('Any widget goes here.', style: TextStyle(color: Colors.white70)),
  ),
).show(); // uses navigatorKey — no context needed
// or .show(context); // pass context explicitly
```

---

## API Reference

### `ToasterPro.show({...})`

| Parameter       | Type                         | Default                          | Description                         |
|-----------------|------------------------------|----------------------------------|-------------------------------------|
| `title`         | `String`                     | required                         | Bold title text                     |
| `message`       | `String?`                    | `null`                           | Optional body text                  |
| `type`          | `ToastType`                  | `ToastType.info`                 | Controls colour and icon            |
| `duration`      | `Duration`                   | `Duration(milliseconds: 3500)`   | Auto-dismiss timeout                |
| `position`      | `DelightSnackbarPosition`    | `bottom`                         | `top` or `bottom`                   |
| `onTap`         | `VoidCallback?`              | `null`                           | Called when user taps the toast     |
| `backgroundColor` | `Color?`                   | type-based default               | Override card background colour     |
| `context`       | `BuildContext?`              | `null`                           | Pass to skip navigator key          |

### `ToastType`

```dart
enum ToastType { success, error, warning, info }
```

### `DelightSnackbarPosition`

```dart
enum DelightSnackbarPosition { top, bottom }
```

---

## Example

See the [`example/`](example/) folder for a full runnable demo app showcasing
all toast types, positions, stacking, custom cards, and tap callbacks.

---

## License

[MIT](LICENSE) © 2024 Coding-Frontend

