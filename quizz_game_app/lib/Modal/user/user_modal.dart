import 'package:firebase_auth/firebase_auth.dart';
class UserModal{
  // final User? user;
  final String role;
  final int? id;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final int score;

  UserModal({ this.id, this.displayName, this.email, this.photoUrl, this.role = 'user', this.score = 0});

  Map<String,dynamic> toMap() => {
      'name' : displayName,
      'email' : email,
      'photo' : photoUrl,
      'role' : role,
      'score' : score
    };

  UserModal copyWith(
    {
        String? role,
        int? id,
        String? displayName,
        String? email,
        String? photoUrl,
        int? score
    }
  ){
    return UserModal(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      score: score ?? this.score
    );
  }

  factory UserModal.fromMap(Map<String,dynamic> json) => UserModal(
    id:  json['id'],
    displayName: json['name'],
    email: json['email'],
    photoUrl: json['photo'],
    role: json['role'],
    score: json['score'],
  );

}