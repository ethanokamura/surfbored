import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

extension FirebaseStorageExtensions on FirebaseStorage {
  static final ref = FirebaseStorage.instance.ref();

  static UploadTask? uploadTask;

  /// Upload A File
  /// [filepath] the path where the file is located
  /// [file] the file that needs to be uploaded
  Future<String> uploadFile(String filepath, File file) async {
    try {
      // assign an upload task var to the new task
      uploadTask = ref.child(filepath).putFile(file);
      // get snapshot when the task is complete
      final snapshot = await uploadTask!.whenComplete(() => {});
      // download the snapshot
      final fileURL = await snapshot.ref.getDownloadURL();
      // return file URL
      return fileURL;
    } catch (e) {
      throw Exception('Error uploading file');
    }
  }

  /// Read A File
  /// [filepath] the path where the file is located
  // Future<String> getFileURL(String filepath) async {
  //   try {
  //     // get reference to the file at the given filepath
  //     final imageRef = ref.child(filepath);
  //     // return found data
  //     final url = await imageRef.getDownloadURL();
  //     // success
  //     return url;
  //   } on FirebaseException {
  //     // handle errors
  //     throw Exception('Error getting file URL');
  //   }
  // }

  /// Delete A File
  /// [filepath] the path where the file is located
  Future<void> deleteFile(String filepath) async {
    try {
      // locate the file
      final imageRef = ref.child(filepath);
      // delete the file
      await imageRef.delete();
    } on FirebaseException {
      // handle errors
      throw Exception('Error deleting file');
    }
  }

  // Cancel Task
  Future<void> cancelOperation() async {
    try {
      // Cancel any ongoing upload task
      if (uploadTask != null) await uploadTask!.cancel();
    } catch (e) {
      throw Exception('Error canceling operation');
    }
  }
}
