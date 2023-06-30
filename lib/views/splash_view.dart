import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/supabase_controller.dart';
import 'package:supa_chat/views/chat_home_view.dart';
import 'package:supa_chat/views/login_view.dart';

class SplashView extends ConsumerWidget {

  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supbaseProvider);
    if (supabase.auth.currentSession == null) {
      return const LoginView();
    } else {
      return const ChatHomeView();
    }
  }
}
