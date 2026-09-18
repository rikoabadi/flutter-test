import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class NativeMessageBoxWindows {
  /// Shows a native Windows MessageBox through Win32 API.
  static bool show(String title, String message) {
    final titlePointer = title.toNativeUtf16();
    final messagePointer = message.toNativeUtf16();
    final ownerWindow = GetForegroundWindow();

    try {
      final result = MessageBoxW(
        ownerWindow == 0 ? 0 : ownerWindow,
        messagePointer,
        titlePointer,
        MB_OK | MB_ICONINFORMATION,
      );
      return result == IDOK;
    } finally {
      calloc.free(titlePointer);
      calloc.free(messagePointer);
    }
  }
}
