import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prueba_flutter/features/media/data/models/media_file_model.dart';
import 'package:prueba_flutter/features/media/data/repositories/media_repository_impl.dart';
import 'package:prueba_flutter/features/media/domain/repositories/media_repository.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepositoryImpl();
});

final mediaViewModelProvider =
    StateNotifierProvider<MediaViewModel, MediaState>((ref) {
      final repo = ref.watch(mediaRepositoryProvider);
      return MediaViewModel(repo);
    });

class MediaState {
  final List<MediaFileModel> images;
  final MediaFileModel? video;
  final bool loading;
  final String? error;
  final String? responseMessage;

  MediaState({
    this.images = const [],
    this.video,
    this.loading = false,
    this.error,
    this.responseMessage,
  });

  MediaState copyWith({
    List<MediaFileModel>? images,
    MediaFileModel? video,
    bool? loading,
    String? error,
    String? responseMessage,
  }) {
    return MediaState(
      images: images ?? this.images,
      video: video ?? this.video,
      loading: loading ?? this.loading,
      error: error,
      responseMessage: responseMessage,
    );
  }
}

class MediaViewModel extends StateNotifier<MediaState> {
  final MediaRepository repository;

  MediaViewModel(this.repository) : super(MediaState());

  final _picker = ImagePicker();

  Future<void> selectImage(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar imagen',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Recortar imagen'),
      ],
    );

    if (croppedFile == null) return;

    final updatedImages = [...state.images];

    if (updatedImages.length > index) {
      updatedImages[index] = MediaFileModel(
        path: croppedFile.path,
        type: MediaType.image,
      );
    } else {
      while (updatedImages.length < index) {
        updatedImages.add(MediaFileModel(path: '', type: MediaType.image));
      }
      updatedImages.add(
        MediaFileModel(path: croppedFile.path, type: MediaType.image),
      );
    }

    state = state.copyWith(images: updatedImages);
  }

  Future<void> selectVideo() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      state = state.copyWith(
        video: MediaFileModel(path: file.path, type: MediaType.video),
      );
    }
  }

  Future<void> uploadMedia() async {
    state = state.copyWith(loading: true, error: null);
    String response = '';
    try {
      if (state.images.length == 2) {
        await repository.uploadIne(state.images);
      } else if (state.video != null) {
        response = await repository.uploadVideo(state.video!);
      } else {
        state = state.copyWith(
          loading: false,
          error: "Debe seleccionar al menos 2 imágenes o 1 video.",
          responseMessage: null,
        );
        return;
      }
      state = MediaState(
        loading: false,
        responseMessage: response,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
