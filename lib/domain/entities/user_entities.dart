import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  final String pushToken;

  const UserEntity({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.pushToken,
  });

  @override
  List<Object?> get props => [
        name,
        uid,
        profilePic,
        isOnline,
        phoneNumber,
        groupId,
        pushToken,
      ];
}
