import 'package:flutter/material.dart';
import 'package:supa_chat/env.dart';
import 'package:supa_chat/src/models/group.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key, required this.groupId, required this.user}) : super(key: key);

  final int groupId;
  final User user;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {

  Duration duration = const Duration();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appId,
      appSign: appSign,
      userID: widget.user.id,
      userName: widget.user.username,
      callID: '${widget.groupId}',
      controller: ZegoUIKitPrebuiltCallController(),
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..durationConfig = ZegoCallDurationConfig(
          onDurationUpdate: (newDuration) {
            duration = newDuration;
          }
        )
        ..onHangUp = () {
          Navigator.pop(context, duration);
        }
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}