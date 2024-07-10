// dart packages
import 'dart:typed_data';

// utils
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rando/services/auth.dart';

// 'users/${user.uid}/$filename'
class StorageService {
  StorageService() : ref = FirebaseStorage.instance.ref();
  final Reference ref;
  Future<void> uploadFile(String filepath, Uint8List file) async {
    try {
      final uploadTask = ref.child(filepath).putData(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("could not upload file. $e");
    }
  }

  Future<Uint8List?> getFile(String filepath) async {
    try {
      final imageRef = ref.child(filepath);
      return imageRef.getData();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print("No object exists at the desired reference");
      } else {
        print("could not get file. $e");
      }
    } catch (e) {
      print("unkown error: $e");
    }
    return null;
  }

  Future<void> deleteFile(String filepath) async {
    try {
      final imageRef = ref.child(filepath);
      await imageRef.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print("No object existss at the desired reference");
      } else {
        print("could not get file. $e");
      }
    } catch (e) {
      print("unknown error $e");
    }
  }
}
