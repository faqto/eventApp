import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggingIn = false;

  void _login(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoggingIn = true);

  final app = context.read<AppController>();
  final name = _nameController.text.trim();
  final password = _passwordController.text;

  await Future.delayed(const Duration(seconds: 1)); // simulate API delay

  if (!mounted) return;  

  final success = app.login(name, password); // REAL LOGIN

  if (!mounted) return; 

  if (success) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.main,
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wrong username or password')),
    );
  }

  setState(() => _isLoggingIn = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your password'
                      : null,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoggingIn ? null : () => _login(context),
                    child: _isLoggingIn
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Login"),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: const Text("Create account"),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


