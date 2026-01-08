import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  
  const ProfileHeader({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user.profilePictureUrl != null
                    ? AssetImage(user.profilePictureUrl!)
                    : const AssetImage('assets/images/default_profile.png'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}