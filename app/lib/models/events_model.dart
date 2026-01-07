enum EventStatus {
  upcoming,
  ongoing,
  ended,
  cancelled
}

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime dateTime;
  final String location;
  final EventStatus status;
  final String hostId;


  final Set<String> attendeeIds;   
  final Set<String> savedByIds;   
  

  Event({required this.id, 
        required this.title,
        required this.description, 
        required this.category, 
        required this.dateTime , 
        required this.location, 
        required this.status, 
        required this.hostId,
        Set<String>? attendeeIds,
        Set<String>? savedByIds,
        }): attendeeIds = attendeeIds ?? {},
            savedByIds = savedByIds ?? {};

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? dateTime,
    String? location,
    EventStatus? status,
    String? hostId,
    Set<String>? attendeeIds,
    Set<String>? savedByIds
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      status: status ?? this.status,
      hostId: hostId ?? this.hostId,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      savedByIds: savedByIds ?? this.savedByIds
    );
  }
}