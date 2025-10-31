import 'package:equatable/equatable.dart';
import 'package:finmene/utils/res/image_res.dart';

class UserLocal extends Equatable {
  final String uuid, name, email;
  final String? photoUrl;
   
  const UserLocal({
    required this.uuid,
    required this.name,
    required this.email,
    this.photoUrl = ImageRes.imagePerson
  });
  
  @override
  List<Object?> get props => [uuid, email];
  
}