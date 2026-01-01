import 'package:app/models/profile_buttons_model.dart';
import 'package:app/models/profile_stat_model.dart';
import 'package:app/pages/cards/profile_event_card.dart';
import 'package:app/pages/items/profile_stat_item.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileStat stats = ProfileStat(hosted: 6, attended: 67, saved: 12);

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
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
          ),

          const SizedBox(height: 40),

          const Text(
            "Ben",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          const Text(
            "Canacotan, Tagum",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 40),

          const Text(
            "I like to join some game events and other stuff to touch some grass or have fun",
            textAlign: TextAlign.center,
          ),


          const SizedBox(height: 20),

          //stats profile
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            
            decoration: BoxDecoration(
              color: const Color(0xFFB39DFF),
              borderRadius: BorderRadius.circular(8),
                boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatItem(label: 'Hosted', value: stats.hosted.toString()),
                const SizedBox(width: 20),
                StatItem(label: 'Attended', value: stats.attended.toString()),
                const SizedBox(width: 20),
                StatItem(label: 'Saved', value: stats.saved.toString()),
              ],
            ),
          ),

          const SizedBox(height: 20),


          const Text("My Events",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1, color: Colors.grey),

          //profile events list
          ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if(index>0){
                return const ProfileEventCard();
              }else{
                return const Text("No hosted events  ):",
                style: TextStyle(color: Colors.grey),);
              }
            
          }),
          

          const SizedBox(height: 20),

          
          const Text("Account Settings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1, color: Colors.grey),
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
