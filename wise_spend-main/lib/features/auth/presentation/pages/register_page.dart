// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hammad/features/auth/presentation/bloc/register_bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterBloc>().add(
      RegisterRequested(
        fullName: _fullName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B4BFF),
                ),
              ),
              const SizedBox(height: 18),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    outlineField(
                      'Full Name',
                      _fullName,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter full name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    outlineField(
                      'E-mail',
                      _email,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    outlineField(
                      'Phone',
                      _phone,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter phone'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    outlineField(
                      'Password',
                      _password,
                      obscure: true,
                      validator: (v) =>
                      (v == null || v.length < 6) ? '6+ chars' : null,
                    ),
                    const SizedBox(height: 12),
                    outlineField(
                      'Confirm Password',
                      _confirm,
                      obscure: true,
                      validator: (v) => (v != _password.text)
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    // BlocConsumer to handle states
                    BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is RegisterSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Registration successful')),
                          );
                          // TODO: Navigate to main/home page if you want
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return const CircularProgressIndicator();
                        }
                        return Column(
                          children: [
                            gradientButton(
                              text: 'Register',
                              onPressed: _handleRegister,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFF6B8BFF).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Container(
                                  constraints:
                                  const BoxConstraints(minHeight: 44),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Have account? Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable input field
Widget outlineField(
    String hint,
    TextEditingController controller, {
      bool obscure = false,
      String? Function(String?)? validator,
    }) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide:
        const BorderSide(color: Color(0xFF6B5BFF), width: 1.6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide:
        const BorderSide(color: Color(0xFF6B5BFF), width: 2.0),
      ),
    ),
  );
}

/// Gradient button widget
Widget gradientButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B5BFF), Color(0xFF9D6BFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}
