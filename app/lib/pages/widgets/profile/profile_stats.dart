import 'package:app/pages/widgets/profile_stat_item.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int hostedCount;
  final int attendedCount;
  final int savedCount;
  
  const ProfileStats({
    super.key,
    required this.hostedCount,
    required this.attendedCount,
    required this.savedCount,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFB39DFF),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7F5DFB),
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F5DFB).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          ProfileStatItem(
            label: 'Hosted',
            value: hostedCount.toString(),
            icon: Icons.event,
          ),
          ProfileStatItem(
            label: 'Joined',
            value: attendedCount.toString(),
            icon: Icons.group,
          ),
          ProfileStatItem(
            label: 'Saved',
            value: savedCount.toString(),
            icon: Icons.bookmark,
          ),
        ],
      ),
    );
  }
}