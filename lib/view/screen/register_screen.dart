import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          RegisterRequested(
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
        appBar: AppBar(
          title: const Text('Create Account'),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Join CineNova',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Create your account and build your movie collection.',
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
                        return 'Please enter a password.';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller:
                        confirmPasswordController,

                    obscureText: true,

                    decoration:
                        const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon:
                          Icon(Icons.lock_reset),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return 'Please confirm your password.';
                      }

                      if (value !=
                          passwordController.text) {
                        return 'Passwords do not match.';
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
                        onPressed: register,
                        child: const Text(
                          'Create Account',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}