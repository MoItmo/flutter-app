import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gemini_langchain/gemini_langchain.dart';
import 'package:get/get.dart';
import 'package:hammad/features/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:hammad/features/expense/presentation/bloc/expense_bloc.dart';

import 'core/di/injection.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/expense/presentation/bloc/expense_event.dart';
import 'firebase_options.dart';


class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('BLOC EVENT: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('BLOC CHANGE: ${bloc.runtimeType} -> $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('BLOC ERROR: ${bloc.runtimeType} -> $error');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GeminiClient.initialize(apiKey: 'Your-gemini-code');

  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDI();

  Bloc.observer = AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider<ExpenseBloc>(
          create: (_) => sl<ExpenseBloc>()..add(GetExpensesEvent()),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => sl<RegisterBloc>(),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(useMaterial3: true),
      home: const SplashPage(),
    );
  }
}
