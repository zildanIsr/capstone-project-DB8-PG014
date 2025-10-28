import 'package:equatable/equatable.dart';

class UserLocal extends Equatable {
  final String uuid, name, email;
  final String? photoUrl;
  
  const UserLocal({
    required this.uuid,
    required this.name,
    required this.email,
    this.photoUrl
  });
  
  @override
  List<Object?> get props => [uuid, email];
  
}