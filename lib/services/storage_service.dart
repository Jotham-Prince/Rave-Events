import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('EventCovers/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadPic(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('ProfilePics/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
