import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import

class DurationPicker extends StatefulWidget {
  final int hoursDuration;
  final int minutesDuration;
  final DateTime? selectedDateTime;
  final Function(int) onHoursChanged;
  final Function(int) onMinutesChanged;

  const DurationPicker({
    super.key,
    required this.hoursDuration,
    required this.minutesDuration,
    required this.selectedDateTime,
    required this.onHoursChanged,
    required this.onMinutesChanged,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late TextEditingController _daysController;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _updateControllersFromDuration();
    
    // Trigger initial duration calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateAndUpdate();
    });
  }

  void _updateControllersFromDuration() {
    final totalMinutes = (widget.hoursDuration * 60) + widget.minutesDuration;
    final days = totalMinutes ~/ (24 * 60);
    final hours = (totalMinutes % (24 * 60)) ~/ 60;
    final minutes = totalMinutes % 60;

    _daysController = TextEditingController(text: days.toString());
    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
  }

  @override
  void didUpdateWidget(DurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isUpdating && 
        (widget.hoursDuration != oldWidget.hoursDuration || 
         widget.minutesDuration != oldWidget.minutesDuration)) {
      _updateControllersFromDuration();
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _validateAndUpdate() {
    if (_isUpdating) return;
    
    _isUpdating = true;
    
    try {
      // Parse values, treating non-numbers and empty strings as 0
      final days = int.tryParse(_daysController.text.trim()) ?? 0;
      final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
      final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;

      // Ensure values are not negative
      int fixedDays = days < 0 ? 0 : days;
      int fixedHours = hours < 0 ? 0 : hours;
      int fixedMinutes = minutes < 0 ? 0 : minutes;
      
      // Handle overflow: minutes > 59 roll over to hours
      if (fixedMinutes >= 60) {
        fixedHours += fixedMinutes ~/ 60;
        fixedMinutes = fixedMinutes % 60;
      }
      
      // Handle overflow: hours > 23 roll over to days
      if (fixedHours >= 24) {
        fixedDays += fixedHours ~/ 24;
        fixedHours = fixedHours % 24;
      }

      // Update text fields with fixed values (only if different)
      if (days != fixedDays) {
        _daysController.text = fixedDays.toString();
      }
      if (hours != fixedHours) {
        _hoursController.text = fixedHours.toString();
      }
      if (minutes != fixedMinutes) {
        _minutesController.text = fixedMinutes.toString();
      }

      // Calculate total minutes
      final totalMinutes = (fixedDays * 24 * 60) + (fixedHours * 60) + fixedMinutes;
      
      // Only update if changed
      final currentTotalMinutes = (widget.hoursDuration * 60) + widget.minutesDuration;
      if (totalMinutes != currentTotalMinutes) {
        widget.onHoursChanged(totalMinutes ~/ 60);
        widget.onMinutesChanged(totalMinutes % 60);
      }
    } finally {
      _isUpdating = false;
    }
  }

  String? _getErrorText(String label, String value) {
    if (value.isEmpty) return null;
    
    final number = int.tryParse(value);
    if (number == null) return "Invalid number";
    if (number < 0) return "Cannot be negative";
    
    return null;
  }

  // Helper method to format DateTime with AM/PM
  String _formatDateTime(DateTime dateTime) {
    final format = DateFormat('MMM d, yyyy h:mm a'); // Example: Jan 8, 2024 2:30 PM
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(hours: widget.hoursDuration, minutes: widget.minutesDuration);
    final endTime = widget.selectedDateTime?.add(duration);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Duration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Duration input fields
          const Text(
            "Duration",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDurationField("Days", _daysController),
              const SizedBox(width: 8),
              _buildDurationField("Hours", _hoursController),
              const SizedBox(width: 8),
              _buildDurationField("Minutes", _minutesController),
            ],
          ),
          
          // Display end time
          if (widget.selectedDateTime != null && endTime != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.blue.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Event will end: ${_formatDateTime(endTime)}",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "0",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7F5DFB)),
              ),
              errorText: _getErrorText(label, controller.text),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (value) {
              // Only validate if the value is valid or empty
              final number = int.tryParse(value);
              if (value.isEmpty || (number != null && number >= 0)) {
                _validateAndUpdate();
              }
            },
          ),
        ],
      ),
    );
  }
}