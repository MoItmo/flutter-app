import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  final String message;
  final Object? cause;
  const Failure(this.message, {this.cause});


  @override
  List<Object?> get props => [message, cause];
}



class ServerFailure extends Failure { const ServerFailure(super.m, {Object? c}) : super(cause: c); }
class CacheFailure extends Failure { const CacheFailure(super.m, {Object? c}) : super(cause: c); }
class AuthFailure extends Failure { const AuthFailure(super.m, {Object? c}) : super(cause: c); }
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.m, {Object? c}) : super(cause: c);
}