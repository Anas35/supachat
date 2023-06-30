import 'package:supa_chat/src/models/invite.dart';
import 'package:supa_chat/utils/supa_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class InviteRepository {

  final SupabaseClient client;

  InviteRepository({required this.client});

  Future<List<Invite>> inviteRecevied() async {
    try {
      final response = await client.from('invite')
        .select<List<Map<String, dynamic>>>('*, from(*)')
        .eq('to', client.auth.currentUser!.id);
      return response.map(Invite.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<List<Invite>> inviteSend() async {
    try {
      final response = await client.from('invite')
        .select<List<Map<String, dynamic>>>('*, to(*)')
        .eq('from', client.auth.currentUser!.id);
      return response.map(Invite.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<void> inviteUser(String userName) async {
    try {
      final to = await client.from('users').select<Map<String, dynamic>?>('id').eq('username', userName).maybeSingle();
      if (to == null) {
        throw 'No username found';
      }
      await client.from('invite').insert({
        "from": client.auth.currentUser!.id,
        "to": to['id'],
      });
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      if (e is String) {
        throw SupaException(e);
      }
      throw SupaException();
    }
  }

  Future<void> acceptInvite(Invite invite) async {
    try {
      await client.from('rooms').insert({
        "user1": client.auth.currentUser!.id,
        "user2": invite.user.id,
      }).select('id');
      await client.from('invite').update({'accept': true}).eq('id', invite.id);
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

  Future<void> rejectInvite(Invite invite) async {
    try {
      await client.from('invite').update({'accept': false}).eq('id', invite.id);
    } on PostgrestException catch (e) {
      throw SupaException(e.message);
    } catch (e) {
      throw SupaException();
    }
  }

}