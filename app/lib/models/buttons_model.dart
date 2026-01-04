import 'dart:ui';

class ButtonAction {
  final String title;
  final Color color;
  final VoidCallback onTap;

  ButtonAction({
    required this.title,
    required this.color,
    required this.onTap,
  });
}
