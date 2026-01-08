import 'package:app/pages/widgets/edit_profile/avatar_picker.dart';
import 'package:app/pages/widgets/edit_profile/edit_profile_form.dart';
import 'package:app/pages/widgets/edit_profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/controllers/user_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userController = Provider.of<UserController>(context, listen: false);
    final currentUser = userController.currentUser;

    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _bioController.text = currentUser.bio ?? '';
      _selectedAvatarPath = currentUser.profilePictureUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _showAvatarPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final userController = context.read<UserController>();
        return AvatarPicker(
          currentAvatarPath: _selectedAvatarPath,
          availableAvatars: userController.getAvailableAvatars(),
          onAvatarSelected: (avatarPath) {
            setState(() {
              _selectedAvatarPath = avatarPath;
            });
          },
        );
      },
    );
  }

  Future<void> _saveProfile(BuildContext context) async {
    final userController = context.read<UserController>();
    final currentUser = userController.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    final updatedUser = currentUser.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      profilePictureUrl: _selectedAvatarPath ?? currentUser.profilePictureUrl,
    );

    try {
      await userController.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();
    final currentUser = userController.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ProfileAvatar(
              currentAvatarPath: _selectedAvatarPath,
              user: currentUser,
              onTap: () => _showAvatarPicker(context),
            ),
            const SizedBox(height: 20),
            
            EditProfileForm(
              nameController: _nameController,
              bioController: _bioController,
              user: currentUser,
              onSave: () => _saveProfile(context),
            ),
          ],
        ),
      ),
    );
  }
}