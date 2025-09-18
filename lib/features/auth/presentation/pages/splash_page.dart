import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../expense/presentation/pages/expense_page.dart';
import '../bloc/auth_bloc.dart';
import 'home_page.dart';
import 'sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ExpensesPage()),
              );
            } else if (!state.isLoading && state.user == null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking authentication...'),
            ],
          ),
        ),
      ),
    );
  }
}
