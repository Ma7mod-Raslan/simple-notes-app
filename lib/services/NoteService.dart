import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class NoteService {
  final _notesBox = Hive.box<Note>('notesBox');
  final _uuid = Uuid();

  Future<void> addNote(String title, String content, List<String> tags) async {
    final note = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      tags: tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _notesBox.put(note.id, note);
  }

  List<Note> getAllNotes() => _notesBox.values.toList();

  Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    await note.save();
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  List<Note> searchNotes(String query) {
    return _notesBox.values.where((note) {
      final text =
          "${note.title} ${note.content} ${note.tags.join(" ")}".toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();
  }
}
