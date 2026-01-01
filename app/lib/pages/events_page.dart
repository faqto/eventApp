import 'package:app/controllers/app_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/cards/events_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final List<String> _baseCategories  = ["ALL", "Gaming", "Food", "Culture", "Environment","Sports"];
  late List<String> _displayCategories;
  String selectedCategory = "ALL";


  List<Event> filteredEvents(List<Event> events) {
    if (selectedCategory == "ALL") return events;
    return events.where((e) => e.category == selectedCategory).toList();
  }
  
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
    final events = context.watch<AppController>().events;
    final filtered = filteredEvents(events);
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
        child:  filtered.isEmpty
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
          itemCount: filtered.length,
          itemBuilder: (context, index) => EventsCard(event: filtered[index])
        ),
      ),

        ],
      )
    );
  }
}