import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/utils/supa_exception.dart';

extension Context on BuildContext {
  void snackBar(String message, [Color color =  Colors.red]) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension Async<T> on AsyncValue<T> {
  
  void handleListen({
    required void Function() data, 
    required void Function(String) error,
  }) {
    whenOrNull(
      error: (err, _) {
        final message = err is SupaException ? err.message : SupaException().message;
        error(message);
      },
      data: (value) {
        if (value is bool && value) {
          data();
        }
      },
    );
  }

  Widget withData(Widget Function(T) data) {
    return when(
      data: data,
      error: (e, stk) {
        return Center(
          child: Text(e is SupaException ? e.message : SupaException().message),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}


abstract class SupaNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  Future<bool> build() async => false;

  Future<void> wrapper(Future<void> Function() body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await body();
      return true;
    });
  }
}
