import 'package:flutter/material.dart';

class ButtonAction {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  const ButtonAction({
    required this.title,
    required this.onTap,
    required this.color,
    required this.icon,
  });
}
