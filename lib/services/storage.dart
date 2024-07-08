// dart packages
import 'dart:typed_data';

// utils
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/services/auth.dart';

class StorageService {
  StorageService() : ref = FirebaseStorage.instance.ref();
  final Reference ref;
  Future<void> uploadFile(String filename, XFile file) async {
    try {
      var user = AuthService().user!;
      final imageRef = ref.child('users/${user.uid}/$filename');
      final imageBytes = await file.readAsBytes();
      await imageRef.putData(imageBytes);
    } catch (e) {
      print("could not upload file. $e");
    }
  }

  Future<Uint8List?> getFile(String filename) async {
    try {
      var user = AuthService().user!;
      final imageRef = ref.child('users/${user.uid}/$filename');
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

  Future<void> deleteFile(String filename) async {
    try {
      var user = AuthService().user!;
      final imageRef = ref.child('users/${user.uid}/$filename');
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
