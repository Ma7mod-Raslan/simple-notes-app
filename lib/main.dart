import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Initialize Notifications
  await NotificationService.initialize();
  NotificationService.requestPermissions();

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to your Notes & Reminders!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime now = DateTime.now().add(const Duration(seconds: 5));
                await NotificationService.scheduleNotification(
                  id: 0,
                  title: 'Test Reminder',
                  body: 'This is a test notification!',
                  scheduledTime: now,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test reminder scheduled!')),
                );
              },
              child: const Text('Schedule Test Reminder'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add note functionality here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
