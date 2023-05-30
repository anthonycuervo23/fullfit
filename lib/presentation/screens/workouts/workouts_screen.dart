import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  WorkoutsScreenState createState() => WorkoutsScreenState();
}

class WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider.notifier).user;

    final authNotifier = ref.watch(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutsScreen'),
      ),
      body: Center(
        child: Text('${authNotifier.state.status}'),
      ),
    );
  }
}
