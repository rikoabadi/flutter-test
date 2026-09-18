import 'package:flutter/material.dart';

import 'native_message_box.dart';

typedef NativeMessageBoxHandler = Future<bool> Function(
  String title,
  String message,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.nativeMessageBoxHandler = NativeMessageBox.show});

  final NativeMessageBoxHandler nativeMessageBoxHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registrasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: RegistrationPage(nativeMessageBoxHandler: nativeMessageBoxHandler),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    this.nativeMessageBoxHandler = NativeMessageBox.show,
  });

  final NativeMessageBoxHandler nativeMessageBoxHandler;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _submitLocked = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitLocked) {
      return;
    }

    _submitLocked = true;

    try {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }

      if (mounted) {
        setState(() {
          _isSubmitting = true;
        });
      }

      final name = _nameController.text.trim();
      const title = 'Registrasi';
      final message = 'Hallo $name';
      final nativeNotificationShown = await _tryShowNativeNotification(
        widget.nativeMessageBoxHandler,
        title,
        message,
      );

      if (nativeNotificationShown || !mounted) {
        return;
      }

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.removeCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('$title: $message')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitLocked = false;
          _isSubmitting = false;
        });
      } else {
        _submitLocked = false;
      }
    }
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
                        onPressed: (_isSubmitting || _submitLocked) ? null : _submit,
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

  static Future<bool> _tryShowNativeNotification(
    NativeMessageBoxHandler nativeMessageBoxHandler,
    String title,
    String message,
  ) async {
    try {
      return await nativeMessageBoxHandler(title, message);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'registration notification',
          context: ErrorDescription(
            'while showing the native registration notification',
          ),
        ),
      );
      return false;
    }
  }
}
