part of 'image_cubit.dart';

/// Represents the different states a images can be in.
enum ImageStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

/// Represents the state of image-related operations.
class ImageState extends Equatable {
  /// Private constructor for creating [ImageState] instances.
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

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        photoUrl,
        imageFile,
      ];

  /// Creates a new [ImageState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension ImageStateExtensions on ImageState {
  bool get isEmpty => status == ImageStatus.empty;
  bool get isLoading => status == ImageStatus.loading;
  bool get isLoaded => status == ImageStatus.loaded;
  bool get isFailure => status == ImageStatus.failure;
}

/// Extension methods for creating new [ImageState] instances.
extension _ImageStateExtensions on ImageState {
  ImageState fromEmpty() => copyWith(status: ImageStatus.empty);
  ImageState fromLoading() => copyWith(status: ImageStatus.loading);
  ImageState fromLoadedUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, status: ImageStatus.loaded);
  ImageState fromLoadedFile(File imageFile) =>
      copyWith(imageFile: imageFile, status: ImageStatus.loaded);
  ImageState fromFailure(String failure) =>
      copyWith(status: ImageStatus.failure);
}
