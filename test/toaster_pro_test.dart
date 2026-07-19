import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toaster_pro/toaster_pro.dart';

void main() {
  group('ToastType', () {
    test('has four values', () {
      expect(ToastType.values.length, 4);
    });

    test('contains expected variants', () {
      expect(
          ToastType.values,
          containsAll([
            ToastType.success,
            ToastType.error,
            ToastType.warning,
            ToastType.info,
          ]));
    });
  });

  group('DelightSnackbarPosition', () {
    test('has top and bottom values', () {
      expect(
          DelightSnackbarPosition.values,
          containsAll([
            DelightSnackbarPosition.top,
            DelightSnackbarPosition.bottom,
          ]));
    });
  });

  testWidgets('show inserts a toast without an unrelated state change', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    addTearDown(() => ToasterPro.navigatorKey = null);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => ToasterPro.show(
                title: 'Copied',
                message: '#3366FF',
                duration: const Duration(seconds: 5),
              ),
              child: const Text('Copy color'),
            ),
          ),
        ),
      ),
    );
    ToasterPro.navigatorKey = navigatorKey;

    await tester.tap(find.text('Copy color'));
    await tester.pump();

    expect(find.text('Copied'), findsOneWidget);
    expect(find.text('#3366FF'), findsOneWidget);

    // Let flutter_animate's zero-delay restart timer fire before disposal.
    await tester.pump(Duration.zero);
    ToasterPro.dismissAll();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
