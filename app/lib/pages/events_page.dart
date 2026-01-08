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
  final List<String> _baseCategories = ["ALL", "Gaming", "Food", "Culture", "Environment", "Sports", "Music", "Tech", "Community"];
  late List<String> _displayCategories;
  String selectedCategory = "ALL";
  String _searchQuery = ""; 
  final TextEditingController _searchController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _displayCategories = List.from(_baseCategories);
  }
  @override
  void dispose() {
    _searchController.dispose(); 
    super.dispose();
  }

  List<Event> filteredEvents(List<Event> events) {
    List<Event> filtered = events;
    if (selectedCategory != "ALL") {
      filtered = filtered.where((e) => e.category == selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((event) {
        final titleMatch = event.title.toLowerCase().contains(query);
        
        return titleMatch;
      }).toList();
    }
    
    return filtered;
  }

  void _selectCategory(String cat) {
    setState(() {
      if (selectedCategory == cat) {
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
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = "";
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<AppController>().eventController.upcoming;
    final filtered = filteredEvents(events);
    
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search events by title...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                        tooltip: 'Clear search',
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),

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
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "Search results for \"$_searchQuery\"",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearSearch,
                    child: const Text(
                      "Clear search",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty || selectedCategory != "ALL"
                              ? Icons.search_off
                              : Icons.event_note,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "No events found for \"$_searchQuery\""
                              : selectedCategory != "ALL"
                                  ? "No events in $selectedCategory category"
                                  : "No events listed",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty || selectedCategory != "ALL")
                          const SizedBox(height: 8),
                        if (_searchQuery.isNotEmpty || selectedCategory != "ALL")
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = "";
                                _searchController.clear();
                                selectedCategory = "ALL";
                                _displayCategories = List.from(_baseCategories);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade50,
                              foregroundColor: Colors.blue,
                              elevation: 0,
                            ),
                            child: const Text("Clear all filters"),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => EventsCard(event: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}