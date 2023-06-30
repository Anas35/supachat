import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/src/controllers/auth_controller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final zegoProvider = Provider<ZegoUIKit>((ref) {
  return ZegoUIKit();
});

final zegoLogInProvider = FutureProvider<void>((ref) async {
  final zego = ref.watch(zegoProvider);
  final user = await ref.watch(currentUserProvider.future);
  zego.login(user.id, user.username);
});