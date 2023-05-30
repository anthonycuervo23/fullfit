import 'package:flutter/material.dart';

class FitnessGoalScreen extends StatelessWidget {
  const FitnessGoalScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitnessGoalScreen'),
      ),
      body: const Center(
        child: Text('FitnessGoalScreen'),
      ),
    );
  }
}
