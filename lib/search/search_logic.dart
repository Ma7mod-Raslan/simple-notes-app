import 'package:simple_notes_app/models/note.dart';

class SearchLogic {
  List<Note> searchNotes(List<Note> allNotes, String query) {
    if (query.isEmpty) {
      return List<Note>.from(allNotes);
    } else {
      return allNotes.where((note) {
        final titleMatch = note.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        final contentMatch = note.content.toLowerCase().contains(
          query.toLowerCase(),
        );
        return titleMatch || contentMatch;
      }).toList();
    }
  }
}
