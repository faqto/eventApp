import 'package:app/model/events_model.dart';
import 'package:app/pages/cards/events_card.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final List<String> _baseCategories  = ["ALL", "Gaming", "Food", "Culture", "Environment"];
  late List<String> _displayCategories;
  String selectedCategory = "ALL";

  List<Event> get filteredEvents {
  if (selectedCategory == "ALL") {
    return events;
  }
  return events
      .where((event) => event.category == selectedCategory)
      .toList();
}

  final List<Event> events = [
    Event(
      "Gaming Tournament",
      "Join competitive players and win prizes.",
      "Gaming",
      "Sept 20, 2025",
      "Tagum",
    ),
    Event(
      "Food Festival",
      "Taste dishes from local chefs.",
      "Food",
      "Oct 5, 2025",
      "Cebu",
    ),
    Event(
      "Cultural Night",
      "Celebrate traditions and performances.",
      "Culture",
      "Nov 12, 2025",
      "Davao",
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _displayCategories = List.from(_baseCategories);
  }
  
  // Handle category selection
    void _selectCategory(String cat) {
    setState(() {
      if (selectedCategory == cat) {
        // Unselect > reset order
        selectedCategory = "ALL";
        _displayCategories = List.from(_baseCategories);
      } else {
        selectedCategory = cat;
        _displayCategories = [
          cat,
          ..._baseCategories.where((c) => c != cat)
        ];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(5),
      child: Column(
        children: [

          //search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
              hintText: "Search events",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ), 
            ),
          ),

          //filter chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _displayCategories.map((cat) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (_) => _selectCategory(cat),
              ),
            )).toList(),
            ),
          ),
        ),

        //event cards
        Expanded(
        child:  filteredEvents.isEmpty
      ? Center(
          child: Text(
            "No event listed  ):",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      : ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            return EventsCard(event: filteredEvents[index]);
          },
        ),
      ),

        ],
      )
    );
  }
}