import 'dart:io';

import 'native_message_box_windows.dart' deferred as native_message_box_windows;

class NativeMessageBox {
  static Future<void>? _loadLibraryFuture;

  static Future<bool> show(String title, String message) async {
    if (!Platform.isWindows) {
      return false;
    }

    await (_loadLibraryFuture ??= native_message_box_windows.loadLibrary());

    return native_message_box_windows.NativeMessageBoxWindows.show(
      title,
      message,
    );
  }
}
