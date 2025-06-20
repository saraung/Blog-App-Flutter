import 'package:blog_app/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email});
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
  UserModel copywith({
  String? id,
  String? email,
  String? name,
}) {
  return UserModel(
      id: id ?? this.id, name: name ?? this.name, email: email ?? this.name);
}

}

