import 'dart:ui';

class ProfileAction {
  final String title;
  final Color color;
  final VoidCallback onTap;

  ProfileAction({
    required this.title,
    required this.color,
    required this.onTap,
  });
}
