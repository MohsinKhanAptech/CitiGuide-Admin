import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.autofocus = false,
    this.suffixIcon,
    this.suffixIconActive,
  });
  final TextEditingController controller;
  final bool obscureText;
  final bool autofocus;
  final String labelText;
  final IconData? suffixIcon;
  final IconData? suffixIconActive;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  IconData? icon;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    icon = widget.suffixIcon;
    obscureText = widget.obscureText;
  }

  void onPressed() {
    setState(() {
      if (icon == widget.suffixIcon) {
        obscureText = false;
        icon = widget.suffixIconActive;
      } else {
        obscureText = true;
        icon = widget.suffixIcon;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.obscureText) {
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
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
