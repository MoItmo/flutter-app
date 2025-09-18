import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _signOut(BuildContext context) {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc b) => b.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text('Welcome, ${user.email ?? user.uid}'),
              const SizedBox(height: 8),
              Text('UID: ${user.uid}'),
            ] else
              const Text('No user data available'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Go to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
