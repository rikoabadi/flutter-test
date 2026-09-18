import 'dart:io';

import 'native_message_box_windows.dart' deferred as native_message_box_windows;

class NativeMessageBox {
  static Future<void>? _loadLibraryFuture;

  static Future<bool> show(String title, String message) async {
    if (!Platform.isWindows) {
      return false;
    }

    try {
      await (_loadLibraryFuture ??= native_message_box_windows.loadLibrary());
    } catch (_) {
      _loadLibraryFuture = null;
      rethrow;
    }

    return native_message_box_windows.NativeMessageBoxWindows.show(
      title,
      message,
    );
  }
}
