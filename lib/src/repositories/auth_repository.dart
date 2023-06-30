import 'package:supa_chat/src/models/group.dart';
import 'package:supa_chat/utils/supa_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRepository {

  AuthRepository({required this.client});

  final SupabaseClient client;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': name,
        }
      );
    } on AuthException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<User> currentUser() async {
    try {
      final id = client.auth.currentUser!.id;
      final json = await client.from('users').select<Map<String, dynamic>>().eq('id', id).single();
      return User.fromJson(json);
    } on AuthException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

}