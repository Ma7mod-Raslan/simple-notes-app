import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/provider/search_state.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final TextEditingController _searchController;
  late final SearchState _searchState;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchState = context.read<SearchState>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String value) {
    _searchState.updateSearch(value);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchState.clearSearch();
    FocusScope.of(context).unfocus(); // Optional: Dismiss keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearch,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: _clearSearch,
          )
              : null,
          hintText: "Search your notes",
          hintStyle: const TextStyle(color: Colors.grey),
          fillColor: Colors.grey.shade800,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}