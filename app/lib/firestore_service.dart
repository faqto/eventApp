import 'package:app/models/events_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/chat_model.dart';
import 'package:app/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'events';
  final String chatCollection = 'chat_messages';
  final String usersCollection = 'users'; 
  // ================== EVENTS ==================

  Future<void> addOrUpdateEvent(Event event) async {
    await _db.collection(collection).doc(event.id).set({
      'title': event.title,
      'description': event.description,
      'category': event.category,
      'dateTime': event.dateTime,
      'endTime': event.endTime,
      'location': event.location,
      'status': event.status.name,
      'hostId': event.hostId,
      'attendeeIds': event.attendeeIds.toList(),
      'savedByIds': event.savedByIds.toList(),
      'createdAt': FieldValue.serverTimestamp(), 
      'updatedAt': FieldValue.serverTimestamp(), 
    }, SetOptions(merge: true));
  }

  Stream<List<Event>> streamEvents() {
    return _db
        .collection(collection)
        .orderBy('dateTime') 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          dateTime: _parseTimestamp(data['dateTime']),
          endTime: _parseTimestamp(data['endTime']),
          location: data['location'] ?? '',
          status: _parseEventStatus(data['status']),
          hostId: data['hostId'] ?? '',
          attendeeIds: Set<String>.from(data['attendeeIds'] ?? []),
          savedByIds: Set<String>.from(data['savedByIds'] ?? []),
        );
      }).toList();
    });
  }
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp != null) {
      try {
        if (timestamp is String) {
          return DateTime.parse(timestamp);
        } else if (timestamp is int) {
          return DateTime.fromMillisecondsSinceEpoch(timestamp);
        }
      } catch (e) {
        print('Error parsing timestamp: $e');
      }
    }
    return DateTime.now();
  }

  EventStatus _parseEventStatus(dynamic status) {
    if (status is String) {
      try {
        return EventStatus.values.firstWhere(
          (e) => e.name == status,
          orElse: () => EventStatus.upcoming,
        );
      } catch (e) {
        return EventStatus.upcoming;
      }
    }
    return EventStatus.upcoming;
  }

  Future<Event?> getEventById(String eventId) async {
    try {
      final doc = await _db.collection(collection).doc(eventId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          dateTime: _parseTimestamp(data['dateTime']),
          endTime: _parseTimestamp(data['endTime']),
          location: data['location'] ?? '',
          status: _parseEventStatus(data['status']),
          hostId: data['hostId'] ?? '',
          attendeeIds: Set<String>.from(data['attendeeIds'] ?? []),
          savedByIds: Set<String>.from(data['savedByIds'] ?? []),
        );
      }
    } catch (e) {
      print('Error getting event by ID: $e');
    }
    return null;
  }

  Future<void> deleteEvent(String eventId) async {
    await _db.collection(collection).doc(eventId).delete();
  }

  Future<void> updateEventFields(String eventId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection(collection).doc(eventId).update(updates);
  }

  // ================== USERS ==================

  Future<void> addOrUpdateUser(User user) async {
    await _db.collection(usersCollection).doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'profilePictureUrl': user.profilePictureUrl,
      'bio': user.bio,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _db.collection(usersCollection).doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          profilePictureUrl: data['profilePictureUrl'],
          bio: data['bio'],
        );
      }
    } catch (e) {
      print('Error getting user by ID: $e');
    }
    return null;
  }

  Stream<List<User>> streamUsers() {
    return _db.collection(usersCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          profilePictureUrl: data['profilePictureUrl'],
          bio: data['bio'],
        );
      }).toList();
    });
  }

  // ================== CHAT ==================

  Future<void> addChatMessage(ChatMessage message) async {
    await _db.collection(chatCollection).doc(message.id).set(message.toMap());
  }

  Stream<List<ChatMessage>> streamChatMessages(String eventId) {
    return _db
        .collection(chatCollection)
        .where('eventId', isEqualTo: eventId)
        .orderBy('timestamp', descending: false) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    });
  }

  Future<List<ChatMessage>> loadAllChatMessages(String eventId) async {
    try {
      final querySnapshot = await _db
          .collection(chatCollection)
          .where('eventId', isEqualTo: eventId)
          .orderBy('timestamp', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading chat messages: $e');
      return [];
    }
  }
  Future<void> deleteEventChatMessages(String eventId) async {
    final querySnapshot = await _db
        .collection(chatCollection)
        .where('eventId', isEqualTo: eventId)
        .get();
    
    final batch = _db.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteChatMessage(String messageId) async {
    await _db.collection(chatCollection).doc(messageId).delete();
  }

  Stream<List<ChatMessage>> streamRecentChatMessages(String eventId, {int limit = 50}) {
  return _db
      .collection(chatCollection)
      .where('eventId', isEqualTo: eventId)
      .orderBy('timestamp', descending: false) 
      .limit(limit)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatMessage(
        id: doc.id,
        eventId: data['eventId'] ?? '',
        senderId: data['senderId'] ?? '',
        senderName: data['senderName'] ?? '', 
        senderProfilePic: data['senderProfilePic'] ?? 'assets/images/default_profile.png',
        text: data['text'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(), 
      );
    }).toList();
  });
}

  Stream<List<Event>> searchEvents({
    String? query,
    String? category,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    CollectionReference eventsRef = _db.collection(collection);
    Query queryRef = eventsRef;

    if (query != null && query.isNotEmpty) {
      queryRef = queryRef.where('title', isGreaterThanOrEqualTo: query);
    }
    
    if (category != null && category.isNotEmpty) {
      queryRef = queryRef.where('category', isEqualTo: category);
    }
    
    if (fromDate != null) {
      queryRef = queryRef.where('dateTime', isGreaterThanOrEqualTo: fromDate);
    }
    
    if (toDate != null) {
      queryRef = queryRef.where('dateTime', isLessThanOrEqualTo: toDate);
    }

    queryRef = queryRef.orderBy('dateTime');

    return queryRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          dateTime: _parseTimestamp(data['dateTime']),
          endTime: _parseTimestamp(data['endTime']),
          location: data['location'] ?? '',
          status: _parseEventStatus(data['status']),
          hostId: data['hostId'] ?? '',
          attendeeIds: Set<String>.from(data['attendeeIds'] ?? []),
          savedByIds: Set<String>.from(data['savedByIds'] ?? []),
        );
      }).toList();
    });
  }

  Stream<List<Event>> getUserEvents(String userId, {bool hostedOnly = false}) {
    CollectionReference eventsRef = _db.collection(collection);
    
    if (hostedOnly) {
      return eventsRef
          .where('hostId', isEqualTo: userId)
          .orderBy('dateTime')
          .snapshots()
          .map((snapshot) => _parseEvents(snapshot));
    } else {
      return eventsRef
          .orderBy('dateTime')
          .snapshots()
          .map((snapshot) => _parseEvents(snapshot, userId: userId));
    }
  }

  List<Event> _parseEvents(QuerySnapshot snapshot, {String? userId}) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final event = Event(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        dateTime: _parseTimestamp(data['dateTime']),
        endTime: _parseTimestamp(data['endTime']),
        location: data['location'] ?? '',
        status: _parseEventStatus(data['status']),
        hostId: data['hostId'] ?? '',
        attendeeIds: Set<String>.from(data['attendeeIds'] ?? []),
        savedByIds: Set<String>.from(data['savedByIds'] ?? []),
      );

      if (userId != null) {
        if (event.hostId == userId || event.attendeeIds.contains(userId)) {
          return event;
        }
        return null;
      }
      return event;
    }).where((event) => event != null).cast<Event>().toList();
  }
}