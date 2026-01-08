import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? currentAvatarPath;
  final User user;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.currentAvatarPath,
    required this.user,
    required this.onTap,
  });

  String getAvatarName(String path) {
    final parts = path.split('/');
    final fileName = parts.last.split('.').first;
    return fileName
        .replaceAll('profile', 'Avatar ')
        .replaceAll('default_', 'Default ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  currentAvatarPath ??
                      user.profilePictureUrl ??
                      'assets/images/default_profile.png',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F5DFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        if (currentAvatarPath != null) ...[
          const SizedBox(height: 8),
          Text(
            getAvatarName(currentAvatarPath!),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ],
    );
  }
}