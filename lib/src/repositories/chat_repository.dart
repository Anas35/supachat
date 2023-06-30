import 'dart:io';

import 'package:path/path.dart';
import 'package:supa_chat/src/models/chat_message.dart';
import 'package:supa_chat/src/models/group.dart';
import 'package:supa_chat/utils/supa_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final SupabaseClient client;

  ChatRepository({required this.client});

  late final _userId = client.auth.currentUser!.id;

  Future<List<Group>> getAllGroups() async {
    try {
      final groups = await client
        .from('rooms')
        .select<List<Map<String, dynamic>>>('*, user1(*), user2(*)')
        .or('user1.eq.$_userId, user2.eq.$_userId');
      return groups.map((group) => Group.fromJson(group, _userId)).toList();
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Stream<List<ChatMessage>> getAllChat(int groupId) async* {
    try {
      yield* client
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('room_id', groupId)
        .order('created_at')
        .map((event) {
          return event.map((message) => ChatMessage.fromJson(message, _userId)).toList();
        });
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    try {
      await client.from('chats').insert(chatMessage.toJson());
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<String> upload(int groupId, File file) async {
    try {
      return await client.storage.from('chat').upload('/$groupId/${basename(file.path)}', file);
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }
}