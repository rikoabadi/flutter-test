import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class NativeMessageBox {
  /// Shows a native Windows MessageBox through Win32 API when running on Windows.
  ///
  /// Returns `true` when the native popup is shown and `false` when the current OS is not Windows.
  static bool show(String title, String message) {
    if (!Platform.isWindows) {
      return false;
    }

    final titlePointer = title.toNativeUtf16();
    final messagePointer = message.toNativeUtf16();

    try {
      final result = MessageBox(
        null,
        messagePointer,
        titlePointer,
        MB_OK | MB_ICONINFORMATION,
      );
      return result.value != 0;
    } finally {
      calloc.free(titlePointer);
      calloc.free(messagePointer);
    }
  }
}
