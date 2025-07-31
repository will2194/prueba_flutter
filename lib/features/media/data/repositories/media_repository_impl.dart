import 'dart:convert';
import 'dart:io';

import 'package:prueba_flutter/core/constants.dart';
import 'package:prueba_flutter/core/network/http_client.dart';
import 'package:prueba_flutter/features/media/data/models/media_file_model.dart';
import 'package:prueba_flutter/features/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  @override
  Future<String> uploadIne(List<MediaFileModel> mediaFilesIne) async {
    final imgBytes = await File(mediaFilesIne[0].path).readAsBytes();
    final imgData = base64Encode(imgBytes);

    final img2Bytes = await File(mediaFilesIne[1].path).readAsBytes();
    final img2Data = base64Encode(img2Bytes);

    final response = await httpClient.post(
      Uri.parse("$apiBaseUrl/Ine/PostOCRINEAnversoReverso"),
      body: jsonEncode({
        "anversoINE": imgData,
        "reversoINE": img2Data,
        "anversoINERecortado": imgData,
        "reversoINERecortado": img2Data,
        "idSolicitud": 10250,
      }),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);

      if (data['msgResponse'] != null) {
        final message = data['msgResponse'];
        throw Exception(message);
      }

      throw Exception("Error al subir las imágenes");
    } else {
      final data = jsonDecode(response.body);

      final message = data['msgResponse'];
      return message;
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
      final data = jsonDecode(response.body);

      if (data['msgResponse'] != null) {
        final message = data['msgResponse'];
        throw Exception(message);
      }

      throw Exception("Error al subir el video");
    } else {
      final data = jsonDecode(response.body);

      final message = data['msgResponse'];
      return message;
    }
  }
}
//{"count":0,"next":0,"previous":0,"results":null,"validations":null,"error":true,"msgResponse":"Ya se guardó anteriormente este paso"}