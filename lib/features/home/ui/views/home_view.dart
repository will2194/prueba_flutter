import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_flutter/features/home/data/models/state_model.dart';
import 'package:prueba_flutter/features/home/ui/viewmodels/home_view_model.dart';
import 'package:prueba_flutter/features/media/ui/views/media_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final stateSelected = ref.watch(stateSelectedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : state.error != null
            ? Text("Error: ${state.error}")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<StateModel>(
                    value: stateSelected,
                    hint: const Text("Selecciona una opción"),
                    items: state.stateList.map((state) {
                      return DropdownMenuItem<StateModel>(
                        value: state,
                        child: Text(state.estado),
                      );
                    }).toList(),
                    onChanged: (value) {
                      ref.read(stateSelectedProvider.notifier).state = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MediaView()),
                      );
                    },
                    child: const Text("Cargar Archivos"),
                  ),
                ],
              ),
      ),
    );
  }
}
