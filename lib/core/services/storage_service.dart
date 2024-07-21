// dart packages
import 'dart:io';
import 'dart:typed_data';

// utils
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
      logger.e("could not upload file. $e");
      return '';
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

  /// Read A File
  /// [filepath] the path where the file is located
  Future<String> getFileURL(String filepath) async {
    try {
      // get reference to the file at the given filepath
      final imageRef = ref.child(filepath);
      // return found data
      final url = await imageRef.getDownloadURL();
      // success
      logger.i("file url retrieved: $url");
      return url;
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
    return '';
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

  Future<File> convertToJPG(Uint8List bytes) async {
    // decode image
    img.Image? image = img.decodeImage(bytes);

    // make sure the image is decoded
    if (image == null) throw Exception("error coverting to jpg");

    // save the jpg image to a file
    List<int> jpgBytes = img.encodeJpg(image);
    String dir = (await getTemporaryDirectory()).path;
    File jpgFile = File('$dir/coverImage.jpg');
    return await jpgFile.writeAsBytes(jpgBytes);
  }
}
