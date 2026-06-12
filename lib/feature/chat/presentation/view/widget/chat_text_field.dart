import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;
  final void Function(String)? onSubmitted;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.enabled,
    this.onSubmitted,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onSubmitted: onSubmitted,
      minLines: 1,
      maxLines: 4,
      textInputAction: TextInputAction.send,
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: false,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFF7B8494),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
