import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/models/note.dart';
import 'package:simple_notes_app/provider/search_state.dart';
import 'package:simple_notes_app/screens/home.dart';
import 'package:simple_notes_app/services/NoteService.dart';
import 'package:simple_notes_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  // Initialize Notifications
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  runApp(const SimpleNotesApp());
}

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchState()),
        Provider(create: (_) => NoteService()),
        Provider(create: (_) => NotificationService()),
      ],
      child: MaterialApp(
        title: 'Simple Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey.shade900,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}