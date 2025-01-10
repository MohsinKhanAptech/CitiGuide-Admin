import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.autofocus = false,
  });
  final TextEditingController controller;
  final bool autofocus;
  final String labelText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  IconData? icon;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  void onPressed() {
    setState(() {
      if (icon == Icons.visibility_off) {
        obscureText = false;
        icon = Icons.visibility;
      } else {
        obscureText = true;
        icon = Icons.visibility_off;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: widget.controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(onPressed: onPressed, icon: Icon(icon)),
        border: OutlineInputBorder(),
      ),
    );
  }
}
