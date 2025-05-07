import 'package:flutter/material.dart';
import 'package:simple_notes_app/models/note.dart';
import 'package:simple_notes_app/search/search_logic.dart';
import 'package:simple_notes_app/services/NoteService.dart';

class SearchState extends ChangeNotifier {
  final SearchLogic _searchLogic = SearchLogic();
  List<Note> _filteredNotes = [];
  String _query = '';

  List<Note> get filteredNotes => _filteredNotes;
  String get query => _query;

  Future<void> loadNotes(NoteService noteService) async {
    _filteredNotes = await noteService.getAllNotes();
    notifyListeners();
  }

  void updateSearch(String query) {
    _query = query;
    _filteredNotes = _searchLogic.searchNotes(_filteredNotes, query);
    notifyListeners();
  }

  void sortNotes() {
    _filteredNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    notifyListeners();
  }
}