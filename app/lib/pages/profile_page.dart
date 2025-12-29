import 'package:app/model/profile_buttons_model.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<ProfileAction> actions = [
  ProfileAction(
    title: "Edit Profile",
    color: Colors.grey.shade300,
    onTap: () {},
  ),
  ProfileAction(
    title: "Privacy Settings",
    color: Colors.grey.shade300,
    onTap: () {},
  ),
  ProfileAction(
    title: "Logout",
    color: Colors.red.shade300,
    onTap: () {},
  ),
];


  @override
  @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Username"),
          const Text("location"),
          const Text("description"),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _StatItem(),
              SizedBox(width: 20),
              _StatItem(),
              SizedBox(width: 20),
              _StatItem(),
            ],
          ),

          const SizedBox(height: 20),

          const Text("My Events"),
          const Divider(thickness: 1, color: Colors.grey),

          const Text("No events listed"),

          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final item = actions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: item.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Center(child: Text(item.title)),
                  onTap: item.onTap,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}

class _StatItem extends StatelessWidget {
  const _StatItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("data", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("data", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
