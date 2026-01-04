import 'package:app/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final result = context.read<AppController>().register(
                  _nameController.text,
                  _passwordController.text,
                );

                if (result == null) {
                  Navigator.pushReplacementNamed(context, Routes.main);
                } else {
                  setState(() => error = result);
                }
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
