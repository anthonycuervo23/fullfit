import 'package:flutter/material.dart';

class ProfilePicScreen extends StatelessWidget {
  const ProfilePicScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfilePicScreen'),
      ),
      body: const Center(
        child: Text('ProfilePicScreen'),
      ),
    );
  }
}
