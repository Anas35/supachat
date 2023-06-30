import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/auth_controller.dart';
import 'package:supa_chat/src/controllers/chat_controller.dart';
import 'package:supa_chat/src/controllers/zego_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/views/chat_message_view.dart';
import 'package:supa_chat/views/invite_view.dart';
import 'package:supa_chat/views/login_view.dart';

class ChatHomeView extends ConsumerWidget {
  const ChatHomeView({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatHomeView(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatList = ref.watch(getGroupsProvider);
    ref.watch(zegoLogInProvider);
    ref.listen(authNotifierProvider, (previous, next) { 
      next.handleListen(
        data: () => Navigator.pushAndRemoveUntil(context, LoginView.route(), (route) => false), 
        error: (error) => context.snackBar(error),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_invitation),
            onPressed: () {
              Navigator.push(context, InvitePage.route());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logOut();
            },
          ),
        ],
      ),
      body: chatList.withData((data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final group = data[index];
            return ListTile(
              onTap: () => Navigator.push(context, ChatScreen.route(group.id)),
              title: Text(group.name),
            );
          },
        );
      }),
    );
  }
}
