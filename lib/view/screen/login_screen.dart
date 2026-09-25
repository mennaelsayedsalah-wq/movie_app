import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(
            email: emailController.text.trim(),
            password:
                passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const HomeScreen(),
            ),
            (route) => false,
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },

      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Form(
                key: formKey,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Container(
                        height: 75,
                        width: 75,

                        decoration: BoxDecoration(
                          color: AppColors.Primary,
                          borderRadius:
                              BorderRadius.circular(22),
                        ),

                        child: const Icon(
                          Icons.movie_filter,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Login to continue watching movies.',
                      style: TextStyle(
                        color: AppColors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,

                      decoration:
                          const InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email_outlined),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your email.';
                        }

                        if (!value.contains('@')) {
                          return 'Please enter a valid email.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller:
                          passwordController,

                      obscureText: true,

                      decoration:
                          const InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock_outline),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please enter your password.';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child:
                                CircularProgressIndicator(
                              color:
                                  AppColors.Primary,
                            ),
                          );
                        }

                        return ElevatedButton(
                          onPressed: login,
                          child:
                              const Text('Login'),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },

                        child: const Text(
                          "Don't have an account? Register",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}