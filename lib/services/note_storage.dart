import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/note.dart';

class NoteStorage {
  static const _boxName = 'secureNotesBox';
  static const _keyName = 'hive_encryption_key';
  static final _secureStorage = FlutterSecureStorage();

  static Future<Box<Note>> openEncryptedBox() async {
    var containsKey = await _secureStorage.containsKey(key: _keyName);

    List<int> encryptionKey;
    if (!containsKey) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(key: _keyName, value: key.join(','));
      encryptionKey = key;
    } else {
      final raw = await _secureStorage.read(key: _keyName);
      encryptionKey = raw!.split(',').map((e) => int.parse(e)).toList();
    }

    return await Hive.openBox<Note>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  static Future<void> addNote(Note note) async {
    final box = await openEncryptedBox();
    await box.add(note);
  }

  static Future<List<Note>> getAllNotes() async {
    final box = await openEncryptedBox();
    return box.values.toList();
  }

  static Future<void> deleteNoteAt(int index) async {
    final box = await openEncryptedBox();
    await box.deleteAt(index);
  }

  static Future<void> updateNoteAt(int index, Note updatedNote) async {
    final box = await openEncryptedBox();
    await box.putAt(index, updatedNote);
  }
}
