import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Navigation package
import 'package:technical_test/Services/auth_service.dart';
import '../domain/auths_bloc/auth_bloc.dart';
import '../domain/auths_bloc/auth_event.dart';
import '../domain/auths_bloc/auth_state.dart';

/// LoginPage - Handles user authentication with a simple UI.
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  // void _login() async {
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text.trim();
  //
  //   if (email.isEmpty || password.isEmpty) {
  //     _showErrorMessage('Please fill in both fields.');
  //     return;
  //   }
  //
  //   try {
  //     await authService.signInWithEmailPassword(email, password);
  //     if (mounted) {
  //       context.go('/dashboard');
  //     }
  //   } catch (e) {
  //     _showErrorMessage('Login failed: $e');
  //   }
  // }
  //
  // void _showErrorMessage(String message) {
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message), backgroundColor: Colors.red),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthrState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("SignIn Success")),
            );
            context.go('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("SignIn Failed"), backgroundColor: Colors.red,),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthrState>(
          builder: (context, state) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _emailFocus.unfocus();
                    _passwordFocus.unfocus();
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Login', style: TextStyle(color: Colors
                          .white)),
                      backgroundColor: Colors.black87,
                      centerTitle: true,
                      elevation: 4,
                    ),
                    body: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            color: Colors.grey[850],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 8,
                            child: Padding(
                              padding: EdgeInsets.all(20).copyWith(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom + 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email Input Field
                                  TextField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: const Icon(Icons.email,
                                          color: Colors.blueAccent),
                                      filled: true,
                                      fillColor: Colors.grey[900],
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              12)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 15),

                                  // Password Input Field
                                  TextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(
                                          Icons.lock, color: Colors.blueAccent),
                                      filled: true,
                                      fillColor: Colors.grey[900],
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              12)),
                                    ),
                                    obscureText: true,
                                    style: const TextStyle(color: Colors
                                        .white), // Added for consistency
                                  ),
                                  const SizedBox(height: 25),

                                  // Login Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12)),
                                      elevation: 5,
                                    ),
                                    onPressed: () {
                                      final email = _emailController.text
                                          .trim();
                                      final password = _passwordController.text
                                          .trim();
                                      context.read<AuthBloc>().add(
                                          SignInEvent(email, password));
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Sign Up Navigation
                                  TextButton(
                                    onPressed: () => context.go('/signup'),
                                    child: const Text(
                                      "Don't have an account? Sign Up",
                                      style: TextStyle(color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(), // Fixed typo: CircularPorgressIndicator -> CircularProgressIndicator
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

