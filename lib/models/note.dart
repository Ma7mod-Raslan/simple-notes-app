import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Sample data for development/demo use
List<Note> sampleNotes = [
  Note(
    id: '0',
    title: 'Note1',
    content: 'Content of Note[1]\nRepeated multiple times.',
    tags: ['demo'],
    createdAt: DateTime(2022, 1, 1, 10, 5),
    updatedAt: DateTime(2022, 1, 1, 10, 5),
  ),
  Note(
    id: '1',
    title: 'Note2',
    content: 'Content of Note[2]',
    tags: ['demo'],
    createdAt: DateTime(2022, 1, 2, 12, 0),
    updatedAt: DateTime(2022, 1, 2, 12, 0),
  ),
  // Add other notes similarly...
];
