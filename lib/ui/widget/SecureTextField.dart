import 'package:flutter/material.dart';

class SecureTextField extends StatefulWidget {
  final String text;
  const SecureTextField({super.key, required this.text});

  @override
  State<SecureTextField> createState() => _SecureTextFieldState();
}

class _SecureTextFieldState extends State<SecureTextField> {
  bool _visible = false;
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _visible = true;
              });
            },
            icon: const Icon(Icons.remove_red_eye))
      ],
    );
  }
}
