import 'package:prueba_flutter/features/media/data/models/media_file_model.dart';

abstract class MediaRepository {
  Future<String> uploadIne(List<MediaFileModel> mediaFilesIne);
  Future<String> uploadVideo(MediaFileModel mediaFileVideo);
}
