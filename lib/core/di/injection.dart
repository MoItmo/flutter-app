import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hammad/features/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/auth/domian/repositories/auth_repository.dart';
import '../../features/auth/domian/usecases/register_with_email.dart';
import '../../features/auth/domian/usecases/sign_in_with_email.dart';
import '../../features/auth/domian/usecases/sign_out.dart';
import '../../features/auth/domian/usecases/watch_auth_state.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/expense/data/datasources/expense_remote_datasource.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domian/repositories/expense_repository.dart';
import '../../features/expense/domian/usecases/add_expense.dart';
import '../../features/expense/domian/usecases/delete_expense.dart';
import '../../features/expense/domian/usecases/get_expenses.dart';
import '../../features/expense/domian/usecases/update_usecase.dart';
import '../../features/expense/presentation/bloc/expense_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Core
  //   sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);


  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  //ExpenseRemoteDataSource
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(sl()),
  );
  //ExpenseRepository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Use cases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => WatchAuthState(sl()));
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));

  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));

  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));
  sl.registerFactory(() => RegisterBloc(sl()));

  sl.registerFactory(
    () => ExpenseBloc(getExpenses: sl(), addExpense: sl(), deleteExpense: sl(), updateExpense: sl()),
  );

  //ExpenseBloc
}
