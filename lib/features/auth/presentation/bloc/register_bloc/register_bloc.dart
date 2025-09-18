import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../domian/entity/register_entity.dart';
import '../../../domian/usecases/register_with_email.dart';


part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterWithEmail _registerWithEmail;

  RegisterBloc(this._registerWithEmail) : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    final Either<Failure, RegisterEntity> result =
    await _registerWithEmail(RegisterParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      phone: event.phone,
    ));

    result.fold(
          (failure) => emit(RegisterFailure(failure.message)),
          (user) => emit(RegisterSuccess(user)),
    );
  }
}
