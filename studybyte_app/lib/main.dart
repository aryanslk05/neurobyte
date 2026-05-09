import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/core/theme/app_theme.dart';
import 'package:studybyte/core/theme/theme_notifier.dart';
import 'package:studybyte/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: StudyByteApp(),
    ),
  );
}

class StudyByteApp extends ConsumerWidget {
  const StudyByteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'StudyByte',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}


