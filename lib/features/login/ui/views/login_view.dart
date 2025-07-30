import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_flutter/features/home/ui/views/home_view.dart';
import 'package:prueba_flutter/features/login/ui/viewmodels/login_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailValid = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    ).hasMatch(email);
    if (!emailValid) {
      _showError("Correo inválido");
      return;
    }

    if (password.isEmpty) {
      _showError("La contraseña no puede estar vacía");
      return;
    }

    await ref.read(loginViewModelProvider.notifier).login(email, password);

    final state = ref.read(loginViewModelProvider);
    if (state.isLogin) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            state.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text("Login")),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
