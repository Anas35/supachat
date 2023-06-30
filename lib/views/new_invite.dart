import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/invited_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/utils/widgets/state_button.dart';

class NewInvite extends StatefulWidget {
  const NewInvite({super.key});

  @override
  State<NewInvite> createState() => _NewInviteState();
}

class _NewInviteState extends State<NewInvite> {

  String username = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Invite new member to chat with them',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Username'),
              ),
              onChanged: (value) => username = value,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                if (!isValid) {
                  return '3-24 long with alphanumeric or underscore';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            Consumer(
              builder: (context, ref, child) {
                ref.listen(inviteNotifierProvider, (previous, next) {
                  next.handleListen(
                    data: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invited"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    error: (error) {
                      context.snackBar(error);
                      Navigator.pop(context);
                    },
                  );                    
                });
                final invite = ref.watch(inviteNotifierProvider);
                return SizedBox(
                  width: 200.0,
                  child: StateButton(
                    text: 'Invite',
                    isLoading: invite.isLoading,
                    onPressed: () {
                      ref.read(inviteNotifierProvider.notifier).inviteUser(username);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
