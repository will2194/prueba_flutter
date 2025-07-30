import 'package:prueba_flutter/features/media/data/models/media_file_model.dart';

abstract class MediaRepository {
  Future<bool> uploadIne(List<MediaFileModel> mediaFilesIne);
  Future<String> uploadVideo(MediaFileModel mediaFileVideo);
}
