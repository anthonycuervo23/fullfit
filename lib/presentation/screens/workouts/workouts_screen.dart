import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).person;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutsScreen'),
      ),
      body: Center(
        child: Text('${user?.email}'),
      ),
    );
  }
}
