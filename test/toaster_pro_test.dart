import 'package:flutter_test/flutter_test.dart';
import 'package:toaster_pro/toaster_pro.dart';

void main() {
  group('ToastType', () {
    test('has four values', () {
      expect(ToastType.values.length, 4);
    });

    test('contains expected variants', () {
      expect(ToastType.values, containsAll([
        ToastType.success,
        ToastType.error,
        ToastType.warning,
        ToastType.info,
      ]));
    });
  });

  group('DelightSnackbarPosition', () {
    test('has top and bottom values', () {
      expect(DelightSnackbarPosition.values, containsAll([
        DelightSnackbarPosition.top,
        DelightSnackbarPosition.bottom,
      ]));
    });
  });
}

