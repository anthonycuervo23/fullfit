import 'package:flutter/material.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiometricScreen'),
      ),
      body: const Center(
        child: Text('BiometricScreen'),
      ),
    );
  }
}
