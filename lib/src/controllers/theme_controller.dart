import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_chat/utils/theme.dart';

final currentThemeMode = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});

final supaTheme = Provider<SupaTheme>((ref) => SupaTheme());