import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfoSection extends StatelessWidget {
  final String location;
  final DateTime dateTime;
  final DateTime endDateTime;
  final String description;

  const EventInfoSection({
    super.key,
    required this.location,
    required this.dateTime,
    required this.endDateTime,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
    final formattedTime = DateFormat('h:mma').format(dateTime);

    final formattedEndDate = DateFormat('MM-dd-yyyy').format(endDateTime);
    final formattedEndTime = DateFormat('h:mma').format(endDateTime);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        divider(),
        _buildLocationSection(),
        _buildDateTimeSection(formattedDate, formattedTime,formattedEndDate,formattedEndTime),
        divider(),
        _buildDescriptionSection(),
        divider(),
      ],
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.black,
      thickness: .5,
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(String formattedDate, String formattedTime,String formattedEndDate,String formattedEndTime) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date & Time",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Start
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.circle,
                color: Colors.black,
                size: 8,
              ),
              const SizedBox(width: 6),
              Text(
                formattedTime.toLowerCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // End
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.red.shade600,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                formattedEndDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.circle,
                color: Colors.black,
                size: 8,
              ),
              const SizedBox(width: 6),
              Text(
                formattedEndTime.toLowerCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        description,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
