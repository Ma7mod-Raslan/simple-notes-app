import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/constants/colors.dart';
import 'package:simple_notes_app/models/note.dart';
import 'package:simple_notes_app/provider/search_state.dart';
import 'package:simple_notes_app/search/search_widget.dart';
import 'package:simple_notes_app/services/NoteService.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshNotes();
    });
  }

  Future<void> _refreshNotes() async {
    await context.read<SearchState>().loadNotes(context.read<NoteService>());
  }

  Color getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text(
                  "Note Ninjas",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<SearchState>().sortNotes();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notes sorted by last updated')),
                    );
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sort, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const SearchWidget(), // Updated to use the self-contained version
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<SearchState>(
                builder: (context, state, _) {
                  if (state.filteredNotes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notes found',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshNotes,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 30),
                      itemCount: state.filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = state.filteredNotes[index];
                        return _buildNoteCard(context, note, state);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditScreen(),
            ),
          );
          if (result != null) {
            await context.read<NoteService>().addNote(result);
            await _refreshNotes();
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.add, size: 38, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, SearchState state) {
    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      color: getRandomColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () async {
            final updatedNote = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditScreen(note: note),
              ),
            );
            if (updatedNote != null) {
              await context.read<NoteService>().updateNote(updatedNote);
              await _refreshNotes();
            }
          },
          title: RichText(
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: '${note.title}\n',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: note.content,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: note.tags.map((tag) =>
                        Chip(
                          label: Text(tag),
                          backgroundColor: Colors.black.withOpacity(0.1),
                        )).toList(),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created: ${DateFormat('MMM d, yyyy').format(
                          note.createdAt)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Edited: ${DateFormat('MMM d, yyyy').format(
                          note.updatedAt)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: const Text('Delete Note'),
                      content: const Text(
                          'Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );

              if (shouldDelete == true) {
                await context.read<NoteService>().deleteNote(note.id);
                await _refreshNotes();
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}