import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prueba_flutter/features/media/ui/viewmodels/media_view_model.dart';

class MediaView extends ConsumerWidget {
  const MediaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaViewModelProvider);
    final vm = ref.read(mediaViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Subir Imagen o Video")),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          children: [
            Column(
              children: List.generate(2, (index) {
                final hasImage = state.images.length > index;
                final imagePath = hasImage ? state.images[index].path : null;

                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => selectImagen(context, vm, index),
                      child: Text("Agregar imagen"),
                    ),
                    if (hasImage)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.file(
                          File(imagePath!),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                );
              }),
            ),
            ElevatedButton(
              onPressed: () => vm.selectVideo(),
              child: const Text("Seleccionar video"),
            ),
            const SizedBox(height: 20),
            state.loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: vm.uploadMedia,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Subir"),
                  ),
            const SizedBox(height: 20),
            state.error != null
                ? Text(state.error!, style: const TextStyle(color: Colors.red))
                : const SizedBox(),
            state.responseMessage != null
                ? Text(
                    state.responseMessage!,
                    style: const TextStyle(color: Colors.green),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void selectImagen(BuildContext context, MediaViewModel vm, int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                vm.selectImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Desde galería'),
              onTap: () {
                Navigator.pop(context);
                vm.selectImage(index, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
