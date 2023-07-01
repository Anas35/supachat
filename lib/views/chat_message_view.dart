import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:supa_chat/src/controllers/auth_controller.dart';
import 'package:supa_chat/src/controllers/chat_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/views/call_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends ConsumerStatefulWidget {
  final int groupId;

  const ChatScreen({super.key, required this.groupId});

  static Route<void> route(int groupId) {
    return MaterialPageRoute(
      builder: (context) => ChatScreen(groupId: groupId),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(getMessageProvider(widget.groupId));
    ref.listen(uploadFileNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data.isNotEmpty) {
            ref.watch(chatNotifierProvider.notifier).sendMessage(widget.groupId, '', data);
          }
        },
        error: (error, _) => context.snackBar('Couldn\'t upload file, please try again'),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async {
              final user = await ref.read(currentUserProvider.future);
              if (context.mounted) {
                ref.read(chatNotifierProvider.notifier).sendMessage(widget.groupId, 'Voice call: ${user.username} joined');
                final duration = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CallPage(groupId: widget.groupId, user: user),
                ));
                if (duration != null && duration is Duration) {
                  final stringDuration = duration.toString();
                  final formated = stringDuration.substring(0, stringDuration.indexOf('.'));
                  ref.read(chatNotifierProvider.notifier).sendMessage(widget.groupId, 'Voice call End by ${user.username}. Duration: $formated');
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.withData((data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final msg = data[data.length - 1 - index];
                  if (msg.message.startsWith("Voice call")) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200.0,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.all(
                              Radius.circular(10.0),
                            ),
                            border: Border.all(
                              color: Colors.black87,
                            ),
                          ),
                          child: Text(msg.message),
                        ),
                      ),
                    );
                  } else if (msg.file != null) {
                    return FileBubble(
                      file: msg.file!,
                      dateTime: msg.createdAt,
                      isSender: msg.isSender,
                    );
                  } else {
                    return ChatBubble(
                      message: msg.message,
                      dateTime: msg.createdAt,
                      isSender: msg.isSender,
                    );
                  }
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      ref.read(uploadFileNotifierProvider.notifier).uploadImage(
                            widget.groupId,
                            File(result.files.single.path!),
                          );
                    }
                  },
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    ref
                        .read(chatNotifierProvider.notifier)
                        .sendMessage(widget.groupId, controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FileBubble extends StatelessWidget {
  final String file;
  final DateTime dateTime;
  final bool isSender;

  const FileBubble({super.key, required this.file, required this.dateTime, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 60.0,
          width: 250.0,
          decoration: BoxDecoration(
            color: isSender ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basename(file),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isSender ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '10/1/1020',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isSender ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.download,
                  size: 24.0,
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime dateTime;
  final bool isSender;

  const ChatBubble(
      {super.key, required this.message, required this.dateTime, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 60.0,
          width: 250.0,
          decoration: BoxDecoration(
            color: isSender ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                basename(message),
                style: TextStyle(
                  fontSize: 16.0,
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(timeago.format(dateTime),
                style: TextStyle(
                  fontSize: 12.0,
                  color: isSender ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
