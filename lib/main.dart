import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BenchmarkApp());
}

class BenchmarkApp extends StatelessWidget {
  const BenchmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Benchmark App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        canvasColor: const Color(0xFF1E1E1E),
      ),
      home: const BenchmarkScreen(),
    );
  }
}

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  final TextEditingController _numberController = TextEditingController(
    text: '2000',
  );

  String _resultText = '';
  int _lastEncodedJsonLength = 0;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  int _parseN() {
    final parsed = int.tryParse(_numberController.text) ?? 0;
    return parsed < 0 ? 0 : parsed;
  }

  void _onTestPressed() {
    final n = _parseN();
    final stopwatch = Stopwatch()..start();

    int total = 0;
    for (int i = 1; i <= n; i++) {
      total += (i % 7);
    }

    stopwatch.stop();

    setState(() {
      _resultText =
          'Execution time: ${stopwatch.elapsedMilliseconds} ms | Hasil: $total';
    });
  }

  void _onTestArrayPressed() {
    final n = _parseN();
    final stopwatch = Stopwatch()..start();

    final items = List.generate(n, (index) {
      final i = index + 1;
      return <String, dynamic>{
        'id': i,
        'name': 'User_$i',
        'score': i * 1.5,
      };
    });

    final encoded = jsonEncode(items);
    _lastEncodedJsonLength = encoded.length;

    stopwatch.stop();

    setState(() {
      _resultText =
          'Array manipulation time: ${stopwatch.elapsedMilliseconds} ms | JSON length: $_lastEncodedJsonLength';
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFF5A5A5A), width: 1),
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2C2C2C),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Color(0xFF5A5A5A), width: 1),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 210,
              child: TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  enabledBorder: outlineBorder,
                  focusedBorder: outlineBorder,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _onTestPressed,
                  style: buttonStyle,
                  child: const Text('Test'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _onTestArrayPressed,
                  style: buttonStyle,
                  child: const Text('Test Array'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _resultText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
