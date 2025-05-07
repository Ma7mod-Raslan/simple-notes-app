import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import 'notification_service.dart';

class NoteService {
  final _notesBox = Hive.box<Note>('notesBox');
  final _uuid = const Uuid();

  Future<void> addNote(Note note) async {
    await _notesBox.put(note.id, note);
    if (note.reminderTime != null) {
      await NotificationService.scheduleNoteReminder(note);
    }
  }

  Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    await _notesBox.put(note.id, note);

    // Update reminder
    await NotificationService.cancelNotification(note.id.hashCode);
    if (note.reminderTime != null) {
      await NotificationService.scheduleNoteReminder(note);
    }
  }

  Future<void> deleteNote(String id) async {
    final note = _notesBox.get(id);
    if (note?.reminderTime != null) {
      await NotificationService.cancelNotification(id.hashCode);
    }
    await _notesBox.delete(id);
  }

  List<Note> getAllNotes() => _notesBox.values.toList();

  List<Note> searchNotes(String query) {
    return _notesBox.values.where((note) {
      final text = "${note.title} ${note.content} ${note.tags.join(" ")}".toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();
  }
}