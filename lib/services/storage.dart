// dart packages
import 'dart:typed_data';

// utils
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

// FireBase Storage Service Provider
class StorageService {
  // Constructor
  StorageService() : ref = FirebaseStorage.instance.ref();
  final Reference ref;

  // allows us to print errors to the console in a nicer way
  final logger = Logger();

  // track upload tasks to cancel if needed (helps prevent mem leaks)
  UploadTask? uploadTask;

  /// Upload A File
  /// [filepath] the path where the file is located
  /// [file] the file that needs to be uploaded
  Future<void> uploadFile(String filepath, Uint8List file) async {
    try {
      // assign an upload task var to the new task
      uploadTask = ref.child(filepath).putData(file);
      // make sure upload task succeeds
      if (uploadTask != null) {
        // get snapshot when the task is complete
        final snapshot = await uploadTask!.whenComplete(() => {});
        // download the snapshot
        await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      logger.e("could not upload file. $e");
    }
  }

  /// Read A File
  /// [filepath] the path where the file is located
  Future<Uint8List?> getFile(String filepath) async {
    try {
      // get reference to the file at the given filepath
      final imageRef = ref.child(filepath);
      // return found data
      return imageRef.getData();
    } on FirebaseException catch (e) {
      // handle errors
      if (e.code == 'object-not-found') {
        logger.w("No object exists at the desired reference");
      } else {
        logger.e("could not get file. $e");
      }
    } catch (e) {
      logger.e("unkown error: $e");
    }
    return null;
  }

  /// Delete A File
  /// [filepath] the path where the file is located
  Future<void> deleteFile(String filepath) async {
    try {
      // locate the file
      final imageRef = ref.child(filepath);
      // delete the file
      await imageRef.delete();
    } on FirebaseException catch (e) {
      // handle errors
      if (e.code == 'object-not-found') {
        logger.w("No object existss at the desired reference");
      } else {
        logger.e("could not get file. $e");
      }
    } catch (e) {
      logger.e("unknown error $e");
    }
  }

  // Cancel Task
  Future<void> cancelOperation() async {
    try {
      // Cancel any ongoing upload task
      if (uploadTask != null) await uploadTask!.cancel();
    } catch (e) {
      logger.e("Error cancelling upload task: $e");
    }
  }
}
