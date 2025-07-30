import 'dart:convert';
import 'dart:io';

import 'package:prueba_flutter/core/constants.dart';
import 'package:prueba_flutter/core/network/http_client.dart';
import 'package:prueba_flutter/features/media/data/models/media_file_model.dart';
import 'package:prueba_flutter/features/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  @override
  Future<bool> uploadIne(List<MediaFileModel> mediaFilesIne) async {
    final base64Images = await Future.wait(
      mediaFilesIne.map((img) async {
        final bytes = await File(img.path).readAsBytes();
        return base64Encode(bytes);
      }),
    );

    final response = await httpClient.post(
      Uri.parse("$apiBaseUrl/Ine/PostOCRINEAnversoReverso"),
      body: jsonEncode({
        "anversoINE": base64Images[0],
        "reversoINE": base64Images[1],
        "anversoINERecortado": base64Images[0],
        "reversoINERecortado": base64Images[1],
        "idSolicitud": 10250,
      }),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al subir archivos");
    } else {
      return true;
    }
  }

  @override
  Future<String> uploadVideo(MediaFileModel mediaFileVideo) async {
    final videoBytes = await File(mediaFileVideo.path).readAsBytes();
    final videoData = base64Encode(videoBytes);

    final response = await httpClient.post(
      Uri.parse("$apiBaseUrl/Firma/InsertarVideoFirma"),
      body: jsonEncode({
        "videoBase64": videoData,
        "tipoFirma": 1,
        "idSolicitud": 10250,
      }),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al subir archivos");
    } else {
      final data = jsonDecode(response.body);

      final message = data['msgResponse'];
      return message;
    }
  }
}
