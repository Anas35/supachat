import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/invited_controller.dart';
import 'package:supa_chat/utils/extension.dart';
import 'package:supa_chat/utils/widgets/state_button.dart';
import 'package:supa_chat/views/new_invite.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const InvitePage(),
    );
  }

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Page'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Invitation Received'),
            Tab(text: 'Invited'),
          ],
        ),
      ),
      body: Consumer(builder: (context, ref, _) {
        return TabBarView(
          controller: _tabController,
          children: const [
            ReceivedTab(),
            InvitedTab(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(context: context, builder: (_) => const NewInvite());
        },
        backgroundColor: Colors.green,
        label: const Text('Invite'),
        icon: const Icon(Icons.message),
      ),
    );
  }
}

class ReceivedTab extends ConsumerWidget {
  const ReceivedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivedInvite = ref.watch(getInviteRecevied);
    final acceptInvite = ref.watch(acceptInviteProvider);
    ref.listen(acceptInviteProvider, (previous, next) { 
      next.handleListen(
        data: () {
          context.snackBar("Accpeted", Colors.green);
          ref.invalidate(acceptInviteProvider);
        },
        error: (error) => context.snackBar(error),
      );
    });
    return receivedInvite.withData(
      (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text('No Invite Recevied'),
          );
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final invite = data[index];
            return ListTile(
              title: Text(invite.user.username),
              trailing: invite.accept == null ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StateButton(
                    text: 'Accept', 
                    isLoading: acceptInvite.isLoading,
                    onPressed: () {
                      ref.read(acceptInviteProvider.notifier).accept(invite);
                    },
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      // Reject invitation
                    },
                    child: const Text('Reject'),
                  ),
                ],
              ) : Text(invite.accept! ? 'Accepetd' : 'Rejected'),
            );
          },
        );
      },
    );
  }
}

class InvitedTab extends ConsumerWidget {
  const InvitedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivedInvite = ref.watch(getInviteSend);
    return receivedInvite.withData(
      (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text('No Invite Send'),
          );
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final invite = data[index];
            return ListTile(
              title: Text(invite.user.username),
              subtitle: Text(invite.accept == null ? 
                'Have not yet accept or reject' : 
                'Have ${invite.accept! ? 'accepted' : 'rejected'} the chat request',
              ),
            );
          },
        );
      },
    );
  }
}
