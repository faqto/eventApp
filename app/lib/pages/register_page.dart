import 'package:app/pages/main_page.dart';
import 'package:app/pages/widgets/register/register_footer.dart';
import 'package:app/pages/widgets/register/register_form.dart';
import 'package:app/pages/widgets/login_register_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:app/controllers/user_controller.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;
  String? error;
  bool _obscurePassword = true;

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final bio = _bioController.text.trim();

    setState(() {
      _isRegistering = true;
      error = null;
    });

    try {
      final auth = FirebaseAuth.instance;

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      final currentUser = auth.currentUser;
      
      if (currentUser != null) {
        final userController = context.read<UserController>();
        userController.setFromFirebaseUser(currentUser);
        
        await Future.delayed(const Duration(milliseconds: 500));

        if (bio.isNotEmpty) {
          await userController.updateCurrentUserProfile(
            name: name,
            bio: bio,
          );
        } else {
          await userController.updateCurrentUserProfile(
            name: name,
          );
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      } else {
        setState(() => error = "Registration failed - no user created");
      }

    
    } on fb.FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email already in use";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'operation-not-allowed':
          errorMessage = "Operation not allowed";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak";
          break;
        default:
          errorMessage = e.message ?? "Registration failed";
      }
      setState(() => error = errorMessage);
    } catch (e) {
      setState(() => error = "An unexpected error occurred");
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const LoginRegisterHeader(
                subtitle: "Create Account",
              ),
              const SizedBox(height: 30),
              
              RegisterForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                bioController: _bioController,
                obscurePassword: _obscurePassword,
                onTogglePasswordVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                error: error,
                isRegistering: _isRegistering,
                onRegister: () => _register(context),
              ),
              
              const SizedBox(height: 20),
              const RegisterFooter(),
            ],
          ),
        ),
      ),
    );
  }
}