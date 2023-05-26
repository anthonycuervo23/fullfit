import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutsScreen'),
      ),
      body: const Center(
        child: Text('WorkoutsScreen'),
      ),
    );
  }
}
