import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

final supbaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});