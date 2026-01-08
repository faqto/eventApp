import 'package:app/models/buttons_model.dart';
import 'package:app/pages/widgets/button_action_tile.dart';
import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;
  
  const ProfileActions({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
  });
  
  @override
  Widget build(BuildContext context) {
    final List<ButtonAction> menuActions = [      
      ButtonAction(
        title: "Edit Profile",
        icon: Icons.edit,
        color: Colors.grey.shade300,
        onTap: onEditProfile,
      ),      
      ButtonAction(
        title: "Logout",
        icon: Icons.logout_rounded,
        color: Colors.red.shade300,
        onTap: onLogout,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: menuActions
            .map((action) => ButtonActionTile(action: action))
            .toList(),
      ),
    );
  }
}