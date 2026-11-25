// ignore: deprecated_member_use
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();

  void _processInput() {
    final input = _controller.text;

    if (input == 'Avada Kedavra') {
      setState(() {
        _counter = 0;
      });
      _controller.clear();
      return;
    }

    final intValue = int.tryParse(input);

    if (intValue != null) {
      setState(() {
        _counter += intValue;
      });
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: введіть ціле число або секретну команду.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №1'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Поточне значення лічильника:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введіть число або команду',
                hintText: 'Наприклад: 5, -3 або Avada Kedavra',
              ),
              onSubmitted: (_) => _processInput(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _processInput,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Застосувати', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
