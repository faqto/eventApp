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
  final DateTime date;
  final String location;
  final EventStatus status;
  final String hostId;


  final Set<String> attendeeIds;   
  final Set<String> savedByIds;   
  

  Event(this.id, this.title,
        this.description, 
        this.category, 
        this.date, 
        this.location, 
        this.status, 
        this.hostId,
        Set<String>? attendeeIds,
        Set<String>? savedByIds,
        ):
        attendeeIds = attendeeIds ?? {},
        savedByIds = savedByIds ?? {};

  //copyWith method for updating event details
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    String? location,
    EventStatus? status,
    String? hostId,
    Set<String>? attendeeIds,
    Set<String>? savedByIds
  }) {
    return Event(
      id ?? this.id,
      title ?? this.title,
      description ?? this.description,
      category ?? this.category,
      date ?? this.date,
      location ?? this.location,
      status ?? this.status,
      hostId ?? this.hostId,
      attendeeIds ?? this.attendeeIds,
      savedByIds ?? this.savedByIds
    );
  }
}