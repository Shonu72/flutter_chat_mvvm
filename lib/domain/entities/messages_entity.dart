import 'package:charterer/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String senderId;
  final String recieverid;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;


  const MessageEntity({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  @override
  List<Object?> get props => [
        senderId,
        recieverid,
        text,
        type,
        timeSent,
        messageId,
        isSeen,
        repliedMessage,
        repliedTo,
        repliedMessageType,
      ];
}
