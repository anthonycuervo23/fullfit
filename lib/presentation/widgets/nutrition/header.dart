import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomHeader extends ConsumerWidget {
  final String title;
  final String? name;
  final void Function()? onPressed;
  const CustomHeader({
    super.key,
    required this.title,
    this.name,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeIn(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 600),
            child: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          ),
          IconButton(
            onPressed: onPressed ??
                () {
                  context.push('/nutrition/suggestions/$name');
                },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
