import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/supabase_controller.dart';
import 'package:supa_chat/src/models/chat_message.dart';
import 'package:supa_chat/src/models/group.dart';
import 'package:supa_chat/src/repositories/chat_repository.dart';
import 'package:supa_chat/utils/extension.dart';

class ChatNotifier extends SupaNotifier {
  Future<void> sendMessage(int groupId, String message, [String? file]) async {
    await wrapper(() async {
      final auth = ref.watch(chatProvider);
      final chatMessage = ChatMessage.forRequest(
        message: message,
        userId: ref.watch(supbaseProvider).auth.currentUser!.id,
        groupId: groupId,
        file: file,
      );
      await auth.sendMessage(chatMessage);
    });
  }
}

final chatNotifierProvider = AutoDisposeAsyncNotifierProvider<ChatNotifier, bool>(ChatNotifier.new);

class UploadFileNotifier extends AutoDisposeAsyncNotifier<String> {

  @override
  Future<String> build() async => '';

  Future<void> uploadImage(int groupId, File file) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final chat = ref.watch(chatProvider);
      return await chat.upload(groupId, file);
    });
  }

}

final uploadFileNotifierProvider = AutoDisposeAsyncNotifierProvider<UploadFileNotifier, String>(UploadFileNotifier.new);

final chatProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(client: ref.watch(supbaseProvider));
});

final getGroupsProvider = AutoDisposeFutureProvider<List<Group>>((ref) async {
  return ref.watch(chatProvider).getAllGroups();
});

final getMessageProvider = AutoDisposeStreamProviderFamily<List<ChatMessage>, int>((ref, id) async* {
  yield* ref.watch(chatProvider).getAllChat(id);
});


