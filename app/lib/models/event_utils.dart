import 'package:flutter/material.dart';
import 'events_model.dart';

class EventUtils {
  static String statusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return "Upcoming";
      case EventStatus.ongoing:
        return "Ongoing";
      case EventStatus.ended:
        return "Ended";
      case EventStatus.cancelled:
        return "Cancelled";
    }
  }

  static Color statusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return Colors.green;
      case EventStatus.ongoing:
        return Colors.orange;
      case EventStatus.ended:
        return Colors.grey;
      case EventStatus.cancelled:
        return Colors.red;
    }
  }

}