import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/widgets/profile/profile_actions.dart';
import 'package:app/pages/widgets/profile/profile_bio.dart';
import 'package:app/pages/widgets/profile/profile_events.dart';
import 'package:app/pages/widgets/profile/profile_header.dart';
import 'package:app/pages/widgets/profile/profile_stats.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();
    final currentUser = userController.currentUser;

    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<EventController>(
      builder: (context, eventController, _) {
        final appController = context.watch<AppController>();
        final hostedEvents = appController.hostedEvents.map((e) {
          final latest = eventController.getEventById(e.id);
          return latest ?? e;
        }).toList();

        final upcomingEvents =
            hostedEvents
                .where(
                  (e) =>
                      e.status == EventStatus.upcoming ||
                      e.status == EventStatus.ongoing,
                )
                .toList()
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

        final pastEvents =
            hostedEvents
                .where(
                  (e) =>
                      e.status == EventStatus.ended ||
                      e.status == EventStatus.cancelled,
                )
                .toList()
              ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(user: currentUser),
              
              ProfileBio(user: currentUser),
              
              const SizedBox(height: 24),
              
              ProfileStats(
                hostedCount: appController.hostedCount,
                attendedCount: appController.attendedCount,
                savedCount: appController.savedCount,
              ),
              
              const SizedBox(height: 24),
              
              ProfileEvents(
                upcomingEvents: upcomingEvents,
                pastEvents: pastEvents,
              ),
              
              const SizedBox(height: 40),
              
              ProfileActions(
                onEditProfile: () => Navigator.pushNamed(context, Routes.editProfile),
                onLogout: () => context.read<AppController>().confirmAndLogout(context),
              ),
            ],
          ),
        );
      },
    );
  }
}