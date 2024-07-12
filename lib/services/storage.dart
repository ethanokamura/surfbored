// dart packages
import 'dart:typed_data';

// utils
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class StorageService {
  final logger = Logger();
  StorageService() : ref = FirebaseStorage.instance.ref();
  final Reference ref;
  UploadTask? uploadTask; // Track upload task to cancel if needed

  // create a file
  Future<void> uploadFile(String filepath, Uint8List file) async {
    try {
      UploadTask uploadTask = ref.child(filepath).putData(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      await snapshot.ref.getDownloadURL();
    } catch (e) {
      logger.e("could not upload file. $e");
    }
  }

  // read a file
  Future<Uint8List?> getFile(String filepath) async {
    try {
      final imageRef = ref.child(filepath);
      return imageRef.getData();
    } on FirebaseException catch (e) {
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

  // delete
  Future<void> deleteFile(String filepath) async {
    try {
      final imageRef = ref.child(filepath);
      await imageRef.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        logger.w("No object existss at the desired reference");
      } else {
        logger.e("could not get file. $e");
      }
    } catch (e) {
      logger.e("unknown error $e");
    }
  }

  // cancel task on page leave
  Future<void> cancelOperation() async {
    try {
      // Cancel any ongoing upload task
      if (uploadTask != null) {
        await uploadTask!.cancel();
        logger.i("Upload task cancelled");
      }
    } catch (e) {
      logger.e("Error cancelling upload task: $e");
    }
  }
}
