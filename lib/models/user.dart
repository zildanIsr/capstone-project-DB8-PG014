import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uuid, name, email;
  final String? photoUrl;
  
  const UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    this.photoUrl
  });
  
  @override
  List<Object?> get props => [email];
  
}