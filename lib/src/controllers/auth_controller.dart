import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/supabase_controller.dart';
import 'package:supa_chat/src/models/group.dart';
import 'package:supa_chat/src/repositories/auth_repository.dart';

class AuthNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  Future<bool> build() async => false;

  Future<void> logIn(String email, String password) async {
    state = const AsyncLoading();
    final auth = ref.watch(authProvider);
    state = await AsyncValue.guard(() async {
      await auth.signIn(email: email, password: password);
      return true;
    });
  }

  Future<void> signIn(String email, String password, String name) async {
    state = const AsyncLoading();
    final auth = ref.watch(authProvider);
    state = await AsyncValue.guard(() async {
      await auth.signUp(email: email, password: password, name: name);
      return true;
    });
  }

  Future<void> logOut() async {
    state = const AsyncLoading();
    final auth = ref.watch(authProvider);
    state = await AsyncValue.guard(() async {
      await auth.signOut();
      return true;
    });
  }
}

final authNotifierProvider = AutoDisposeAsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

final currentUserProvider = FutureProvider<User>((ref) async {
  return ref.watch(authProvider).currentUser();
});

final authProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(client: ref.watch(supbaseProvider));
});