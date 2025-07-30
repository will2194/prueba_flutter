enum MediaType { image, video }

class MediaFileModel {
  final String path;
  final MediaType type;

  MediaFileModel({required this.path, required this.type});
}
