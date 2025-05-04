
import 'package:share_plus/share_plus.dart';
import '../models/note.dart';

void shareNote(Note note) {
  final content = 'Title: ${note.title}\n\n${note.content}';
  Share.share(content);
}
