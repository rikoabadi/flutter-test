import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

typedef MessageNotifier = void Function(
  BuildContext context,
  String title,
  String message,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.messageNotifier = RegistrationNotifier.show});

  final MessageNotifier messageNotifier;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registrasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: RegistrationPage(messageNotifier: messageNotifier),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    this.messageNotifier = RegistrationNotifier.show,
  });

  final MessageNotifier messageNotifier;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = _nameController.text.trim();
    final message = 'Hallo $name';
    widget.messageNotifier(context, 'Registrasi', message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Registrasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Input harus di isi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _submit,
                        child: const Text('Registrasi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationNotifier {
  static void show(BuildContext context, String title, String message) {
    if (Platform.isWindows) {
      NativeMessageBox.show(title, message);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class NativeMessageBox {
  /// Shows a native Windows MessageBox through Win32 API.
  ///
  /// Callers should only invoke this on Windows and provide a separate fallback UI elsewhere.
  static void show(String title, String message) {
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
