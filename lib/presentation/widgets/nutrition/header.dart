import 'package:flutter/material.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String name;
  const CustomHeader({
    super.key,
    required this.title,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeTransitionAnimation(
            delay: const Duration(microseconds: 600),
            child: Text(name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          ),
          IconButton(
            onPressed: () {
              //TODO: open search results
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
