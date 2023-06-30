import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/supabase_controller.dart';
import 'package:supa_chat/src/models/invite.dart';
import 'package:supa_chat/src/repositories/invite_repository.dart';

class InviteNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  Future<bool> build() async => false;

  Future<void> inviteUser(String username) async {
    state = const AsyncLoading();
    final auth = ref.watch(inviteProvider);
    state = await AsyncValue.guard(() async {
      await auth.inviteUser(username);
      return true;
    });
  }
}

class AcceptInviteNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  Future<bool> build() async => false;

  Future<void> accept(Invite invite) async {
    state = const AsyncLoading();
    final auth = ref.watch(inviteProvider);
    state = await AsyncValue.guard(() async {
      await auth.acceptInvite(invite);
      return true;
    });
  }
}

class RejectInviteNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  Future<bool> build() async => false;

  Future<void> reject(Invite invite) async {
    state = const AsyncLoading();
    final auth = ref.watch(inviteProvider);
    state = await AsyncValue.guard(() async {
      await auth.rejectInvite(invite);
      return true;
    });
  }
}


final inviteNotifierProvider = AutoDisposeAsyncNotifierProvider<InviteNotifier, bool>(InviteNotifier.new);

final acceptInviteProvider = AutoDisposeAsyncNotifierProvider<AcceptInviteNotifier, bool>(AcceptInviteNotifier.new);

final rejectInviteProvider = AutoDisposeAsyncNotifierProvider<RejectInviteNotifier, bool>(RejectInviteNotifier.new);

final inviteProvider = Provider<InviteRepository>((ref) {
  return InviteRepository(client: ref.watch(supbaseProvider));
});

final getInviteRecevied = AutoDisposeFutureProvider<List<Invite>>((ref) async {
  return ref.watch(inviteProvider).inviteRecevied();
});

final getInviteSend = AutoDisposeFutureProvider<List<Invite>>((ref) async {
  return ref.watch(inviteProvider).inviteSend();
});


