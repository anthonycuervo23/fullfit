import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutritionScreen'),
      ),
      body: const Center(
        child: Text('NutritionScreen'),
      ),
    );
  }
}
