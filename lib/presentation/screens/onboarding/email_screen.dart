import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 53),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 73.0),
            child: Text(
              'Cual es tu correo electronico?',
              textAlign: TextAlign.center,
              style: textStyles.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 29),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Ingresa tu correo electronico',
                hintStyle: textStyles.bodyMedium?.copyWith(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 20,
                ),
                contentPadding: const EdgeInsets.all(20),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
