import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hammad/features/auth/presentation/pages/register_page.dart';
import '../../../expense/presentation/pages/expense_page.dart';
import '../bloc/auth_bloc.dart';
import 'home_page.dart';

/// Styled SignInPage UI (matches the rounded outline fields + purple gradient button
/// from the images). Keeps your existing AuthBloc integration (no auth logic changes).
///
/// Replace the illustration asset path with your own image if needed.
InputDecoration _outlineDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Color(0xFF6B5BFF), width: 1.6),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Color(0xFF6B5BFF), width: 2.0),
    ),
    labelStyle: const TextStyle(color: Color(0xFF6B5BFF)),
  );
}

Widget _gradientButton({required String text, required VoidCallback onPressed, double? width}) {
  final child = ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    ),
  );

  if (width != null) {
    return SizedBox(width: width, child: child);
  }
  return child;
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    context.read<AuthBloc>().add(AuthSignInRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.user != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ExpensesPage()));
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B4BFF),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _outlineDecoration('Username or email'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter email';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: _outlineDecoration('Password'),
                          obscureText: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter password';
                            if (v.length < 6) return 'Password too short';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        // Loading or button
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : _gradientButton(
                          text: 'Sign in',
                          onPressed: _submit,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Get.to(()=>RegisterPage());

                              },
                              child: const Text('Create one', style: TextStyle(color: Color(0xFF6B5BFF))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    height: 220,
                    child: Center(
                      child: Image.asset('assets/images/Group.png', fit: BoxFit.contain),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
