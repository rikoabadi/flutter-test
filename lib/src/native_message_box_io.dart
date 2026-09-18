import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class NativeMessageBox {
  /// Shows a native Windows MessageBox through Win32 API.
  ///
  /// Callers should only invoke this on Windows and provide a separate fallback UI elsewhere.
  static void show(String title, String message) {
    if (!Platform.isWindows) {
      return;
    }

    final titlePointer = title.toNativeUtf16();
    final messagePointer = message.toNativeUtf16();

    try {
      MessageBox(
        null,
        messagePointer,
        titlePointer,
        MB_OK | MB_ICONINFORMATION,
      );
    } finally {
      calloc.free(titlePointer);
      calloc.free(messagePointer);
    }
  }
}
