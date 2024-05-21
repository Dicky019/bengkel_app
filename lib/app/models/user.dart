// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:nylo_framework/nylo_framework.dart';

import 'pengendara.dart';

enum Role { motir, pengendara }

class User extends Model {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final Role role;
  final Pengendara? pengendara;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.role,
    required this.pengendara,
  });

  @override
  toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'imageUrl': imageUrl,
        'role': role.name,
      };

  factory User.empty() {
    return User.fromJson(null);
  }

  factory User.skeletonizer() {
    return User(
      id: 'id',
      firstName: 'firstName',
      lastName: 'lastName',
      email: 'dicky93darmawan@gmail.com',
      imageUrl: 'imageUrl',
      role: Role.pengendara,
      pengendara: null,
    );
  }

  factory User.fromJson(Map<String, dynamic>? map) {
    return User(
      id: map?['id'] ?? '-',
      firstName: map?['firstName'] ?? '-',
      lastName: map?['lastName'] ?? '-',
      email: map?['email'] ?? '-',
      imageUrl: map?['imageUrl'] ?? '-',
      role: map?['role'] == "pengendara" ? Role.pengendara : Role.motir,
      pengendara: null,
    );
  }

  factory User.fromJsonPengendara(
      Map<String, dynamic>? user, Map<String, dynamic>? pengendara) {
    return User(
      id: user?['id'] ?? '-',
      firstName: user?['firstName'] ?? '-',
      lastName: user?['lastName'] ?? '-',
      email: user?['email'] ?? '-',
      imageUrl: user?['imageUrl'] ?? '-',
      role: Role.pengendara,
      pengendara: pengendara == null ? null : Pengendara.fromJson(pengendara),
    );
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    Role? role,
    Pengendara? pengendara,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      pengendara: pengendara ?? this.pengendara,
    );
  }
}
