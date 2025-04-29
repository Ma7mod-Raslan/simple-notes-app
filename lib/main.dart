import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleNotesApp());
}

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatelessWidget {
  const NotesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Notes App')),
      body: const Center(child: Text('Welcome to your Notes App!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // سيتم تنفيذ إضافة ملاحظة جديدة هنا لاحقًا
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
