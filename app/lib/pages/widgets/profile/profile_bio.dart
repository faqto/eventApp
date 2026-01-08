import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileBio extends StatelessWidget {
  final User user;
  
  const ProfileBio({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "About",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.bio?.isNotEmpty == true
                      ? user.bio!
                      : "No bio yet. Tap edit to add one.",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFF7F5DFB)),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
        ],
      ),
    );
  }
}