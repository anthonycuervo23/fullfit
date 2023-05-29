import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileScreen'),
      ),
      body: Center(
        child: FilledButton.tonal(
            onPressed: () => authNotifier.logout(),
            child: const Text('LogOut')),
      ),
    );
  }
}
