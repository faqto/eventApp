import 'package:app/controllers/app_controller.dart';
import 'package:app/models/buttons_model.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/cards/profile_event_card.dart';
import 'package:app/pages/widgets/button_action_tile.dart';
import 'package:app/pages/widgets/profile_stat_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppController>();

    // Split events by status hosted by user
    // upcoming/ongoing and ended separately
    final upcomingEvents = app.hostedEvents
        .where(
          (e) =>
              e.status == EventStatus.upcoming ||
              e.status == EventStatus.ongoing,
        )
        .toList();
    upcomingEvents.sort((a, b) => a.dateTime.compareTo(b.dateTime)); 

    final pastEvents =
        app.hostedEvents.where(
            (e) =>
          e.status == EventStatus.ended || e.status == EventStatus.cancelled,).toList();
    pastEvents.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
   final List<ButtonAction> actions = [
        ButtonAction(
          title: "Edit Profile",
          icon: Icons.edit_rounded,
          color: Colors.grey.shade300,
          onTap: () {},
        ),
        ButtonAction(
          title: "Privacy Settings",
          icon: Icons.lock_outline_rounded,
          color: Colors.grey.shade300,
          onTap: () {},
        ),
        ButtonAction(
          title: "Logout",
          icon: Icons.logout_rounded,
          color: Colors.red.shade300,
          onTap: () => app.confirmAndLogout(context),
        ),
      ];


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            CircleAvatar(
              backgroundImage: AssetImage(
                app.currentUser.profilePictureUrl ??
                    'images/default_profile.png',
              ),
              radius: 50,
              backgroundColor: Colors.grey.shade300,
            ),

            const SizedBox(height: 40),

            Text(
              app.currentUser.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Text(app.currentUser.email, style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 40),

            Text(
              app.currentUser.bio ?? "No bio available",
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
                  StatItem(label: 'Hosted', value: app.hostedCount.toString()),
                  const SizedBox(width: 20),
                  StatItem(label: 'Joined', value: app.attendedCount.toString()),
                  const SizedBox(width: 20),
                  StatItem(label: 'Saved', value: app.savedCount.toString()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "My Events",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1, color: Colors.grey),

            // UPCOMING / ONGOING
            if (upcomingEvents.isNotEmpty) ...[
              const Text(
                "Upcoming",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: upcomingEvents.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProfileEventCard(event: upcomingEvents[index]);
                },
              ),
            ],

            // EMPTY STATE
            if (upcomingEvents.isEmpty)
              const Text(
                "No upcoming events",
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 16),

            // PAST EVENTS
            if (pastEvents.isNotEmpty) ...[
              const Text(
                "Past Events",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: pastEvents.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Opacity(
                    opacity: 0.6, 
                    child: ProfileEventCard(event: pastEvents[index]),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            //profile buttons list
            const Text(
              "Account Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1, color: Colors.grey),

             Column(
                children: actions
                    .map((action) => ButtonActionTile(action: action))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
