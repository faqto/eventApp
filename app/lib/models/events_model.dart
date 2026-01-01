enum EventStatus {
  upcoming,
  ongoing,
  ended,
}

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String location;
  final EventStatus status;
  

  Event(this.id, this.title, this.description, this.category, this.date, this.location, this.status);
}