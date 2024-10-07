part of 'image_cubit.dart';

enum ImageStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

class ImageState extends Equatable {
  const ImageState._({
    this.status = ImageStatus.initial,
    this.photoUrl = '',
    this.imageFile,
  });

  const ImageState.initial() : this._();

  final ImageStatus status;
  final String? photoUrl;
  final File? imageFile;
  // ImageFailure?

  @override
  List<Object?> get props => [
        status,
        photoUrl,
        imageFile,
      ];

  ImageState copyWith({
    ImageStatus? status,
    String? photoUrl,
    File? imageFile,
  }) {
    return ImageState._(
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

extension ImageStateExtensions on ImageState {
  bool get isEmpty => status == ImageStatus.empty;
  bool get isLoading => status == ImageStatus.loading;
  bool get isLoaded => status == ImageStatus.loaded;
  bool get isFailure => status == ImageStatus.failure;
}

extension _ImageStateExtensions on ImageState {
  ImageState fromEmpty() => copyWith(status: ImageStatus.empty);
  ImageState fromLoading() => copyWith(status: ImageStatus.loading);
  ImageState fromLoadedUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, status: ImageStatus.loaded);
  ImageState fromLoadedFile(File imageFile) =>
      copyWith(imageFile: imageFile, status: ImageStatus.loaded);
  ImageState fromFailure(String failure) {
    print('failure: $failure');
    return copyWith(
      status: ImageStatus.failure,
    );
  }
}
