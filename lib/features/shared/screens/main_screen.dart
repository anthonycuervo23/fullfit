import 'package:flutter/material.dart';
import 'package:fullfit_app/features/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  static const name = 'main-screen';
  final StatefulNavigationShell navigationShell;
  const MainScreen({Key? key, required this.navigationShell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar:
          CustomBottomNavigationBar(navigationShell: navigationShell),
    );
  }
}
