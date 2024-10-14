import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(const ImageState.initial());

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage({
    required ImageSource source,
    required double aspectX,
    required double aspectY,
  }) async {
    try {
      emit(state.fromLoading());
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 50);

      if (pickedFile == null) {
        emit(state.fromEmpty());
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: aspectX, ratioY: aspectY),
      );

      if (croppedFile == null) {
        emit(state.fromFailure('Image cropping canceled'));
        return;
      }

      final compressedImage = await _compressImage(File(croppedFile.path));

      if (compressedImage == null) {
        emit(state.fromFailure('Image compression failed'));
        return;
      }
      emit(state.fromLoadedFile(compressedImage));
    } catch (e) {
      emit(state.fromFailure('Failed to pick image'));
    }
  }

  Future<void> pickAndUploadImage({
    required ImageSource source,
    required String userId,
    required int docId,
    required String collection,
    required double aspectX,
    required double aspectY,
  }) async {
    try {
      await pickImage(source: source, aspectX: aspectX, aspectY: aspectY);
      final path = '$userId/image_$docId.jpeg';
      // upload image
      final uploadURL = await Supabase.instance.client.uploadFile(
        collection: collection,
        path: path,
        file: state.imageFile!.readAsBytesSync(),
      );
      emit(state.fromLoadedUrl(uploadURL));
    } catch (e) {
      emit(state.fromFailure('Failed to pick image'));
    }
  }

  Future<void> pickUserImage({
    required ImageSource source,
    required String userId,
    required double aspectX,
    required double aspectY,
  }) async {
    try {
      await pickImage(source: source, aspectX: aspectX, aspectY: aspectY);
      final path = '$userId/image.jpeg';
      final uploadURL = await Supabase.instance.client.uploadFile(
        collection: 'users',
        path: path,
        file: state.imageFile!.readAsBytesSync(),
      );
      emit(state.fromLoadedUrl(uploadURL));
    } catch (e) {
      emit(state.fromFailure('Failed to pick image'));
    }
  }

  // Loading image
  void loadImage(String? url) {
    emit(state.fromLoading());
    emit(state.fromLoadedUrl((url == null || url.isEmpty) ? null : url));
  }

  Future<File?> _compressImage(File file) async {
    final filePath = file.absolute.path;
    final outPath =
        '${filePath.substring(0, filePath.lastIndexOf('.'))}_compressed.jpg';

    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
      );
      return result != null ? File(result.path) : null;
    } catch (e) {
      return null;
    }
  }
}
