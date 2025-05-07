import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/note.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> resultOfSearchedNotes = [];

  @override
  void initState() {
    super.initState();
    resultOfSearchedNotes = sampleNotes;
  }

  void searchInNoteByText(String searchText) {
    setState(() {
      resultOfSearchedNotes = sampleNotes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        final searchLower = searchText.toLowerCase();
        return titleLower.contains(searchLower) || contentLower.contains(searchLower);
      }).toList();
    });
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void deleteNote(int index) {
    setState(() {
      sampleNotes.remove(resultOfSearchedNotes[index]);
      resultOfSearchedNotes.removeAt(index);
    });
  }

  List<Note> sortNotesByupdatedAt(List<Note> notes) {
    List<Note> sortedNotes = List.from(notes);
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  "OurTeamName",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      resultOfSearchedNotes = sortNotesByupdatedAt(
                        resultOfSearchedNotes,
                      );
                    });
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.sort, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextField(
              onChanged: (value) {
                searchInNoteByText(value);
              },
              style: TextStyle(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search your notes by any word",
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 30),
                itemCount: resultOfSearchedNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 25),
                    color: getRandomColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditScreen(
                                note: resultOfSearchedNotes[index],
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              int originalIndex = sampleNotes.indexOf(
                                resultOfSearchedNotes[index],
                              );

                              Note updatedNote = Note(
                                id: result[0],
                                title: result[1],
                                content: result[2],
                                tags: result[3],
                                createdAt: resultOfSearchedNotes[index].createdAt,
                                updatedAt: DateTime.now(),
                              );

                              sampleNotes[originalIndex] = updatedNote;
                              resultOfSearchedNotes[index] = updatedNote;
                            });
                          }
                        },
                        title: RichText(
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${resultOfSearchedNotes[index].title} \n',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: resultOfSearchedNotes[index].content,
                                style: TextStyle(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Created at : ${DateFormat('EEE MMM d, yyyy h:mm a').format(resultOfSearchedNotes[index].createdAt)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              Text(
                                'Edited at : ${DateFormat('EEE MMM d, yyyy h:mm a').format(resultOfSearchedNotes[index].updatedAt)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            deleteNote(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
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
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add(
                Note(
                  id: result[0],
                  title: result[1],
                  content: result[2],
                  tags: result[3],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              resultOfSearchedNotes = sampleNotes;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.add, size: 38, color: Colors.white),
      ),
    );
  }
}
