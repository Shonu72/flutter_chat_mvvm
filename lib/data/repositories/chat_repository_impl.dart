import 'package:charterer/data/datasources/chat_remote_datasource.dart';
import 'package:charterer/data/models/chat_contact_model.dart';
import 'package:charterer/data/models/messages_model.dart';
import 'package:charterer/domain/entities/chat_contact_entity.dart';
import 'package:charterer/domain/entities/messages_entity.dart';
import 'package:charterer/domain/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatContact>> getChatContacts() {
    return remoteDataSource
        .getChatContacts()
        .map((contacts) => contacts.map((contact) => contact).toList());
  }

  @override
  Stream<List<Message>> getChatStream(String receiverUserId) {
    return remoteDataSource
        .getChatStream(receiverUserId)
        .map((messages) => messages.map((message) => message).toList());
  }

  @override
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
  }) {
    remoteDataSource.sendTextMessage(
      context: context,
      text: text,
      receiverUserId: receiverUserId,
    );
  }
}
