import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GenderScreen'),
      ),
      body: const Center(
        child: Text('GenderScreen'),
      ),
    );
  }
}
