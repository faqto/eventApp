import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final String? currentAvatarPath;
  final List<String> availableAvatars;
  final Function(String) onAvatarSelected;

  const AvatarPicker({
    super.key,
    required this.currentAvatarPath,
    required this.availableAvatars,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Choose Your Avatar',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: availableAvatars.length,
          itemBuilder: (context, index) {
            final avatar = availableAvatars[index];
            return GestureDetector(
              onTap: () {
                onAvatarSelected(avatar);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: currentAvatarPath == avatar
                        ? const Color(0xFF7F5DFB)
                        : Colors.grey.shade300,
                    width: currentAvatarPath == avatar ? 3 : 1,
                  ),
                  boxShadow: currentAvatarPath == avatar
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7F5DFB).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: AssetImage(avatar),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}