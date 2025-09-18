import '../../domian/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, super.email});


  factory UserModel.fromFirebaseUser(dynamic user) => UserModel(
    uid: user.uid as String,
    email: user.email as String?,
  );
}