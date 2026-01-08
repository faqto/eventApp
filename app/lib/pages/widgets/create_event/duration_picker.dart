import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // Convert hoursDuration and minutesDuration to days, hours, minutes
    final totalMinutes = (widget.hoursDuration * 60) + widget.minutesDuration;
    final days = totalMinutes ~/ (24 * 60);
    final hours = (totalMinutes % (24 * 60)) ~/ 60;
    final minutes = totalMinutes % 60;

    _daysController = TextEditingController(text: days.toString());
    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
    
    // Trigger initial duration calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateAndUpdate();
    });
  }

  @override
  void didUpdateWidget(DurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.hoursDuration != oldWidget.hoursDuration || 
        widget.minutesDuration != oldWidget.minutesDuration) {
      final totalMinutes = (widget.hoursDuration * 60) + widget.minutesDuration;
      final days = totalMinutes ~/ (24 * 60);
      final hours = (totalMinutes % (24 * 60)) ~/ 60;
      final minutes = totalMinutes % 60;

      _daysController.text = days.toString();
      _hoursController.text = hours.toString();
      _minutesController.text = minutes.toString();
      _validateAndUpdate();
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  bool _isValidNumber(String value) {
    if (value.isEmpty) return true;
    final number = int.tryParse(value);
    return number != null && number >= 0;
  }

  void _validateAndUpdate() {
    final days = int.tryParse(_daysController.text) ?? 0;
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;

    final isValidDays = _isValidNumber(_daysController.text);
    final isValidHours = _isValidNumber(_hoursController.text) && hours < 24;
    final isValidMinutes = _isValidNumber(_minutesController.text) && minutes < 60;

    if (!isValidDays || !isValidHours || !isValidMinutes) {
      return;
    }

    // Calculate total minutes
    final totalMinutes = (days * 24 * 60) + (hours * 60) + minutes;
    
    // Update the parent widget with hours and minutes
    widget.onHoursChanged(totalMinutes ~/ 60);
    widget.onMinutesChanged(totalMinutes % 60);
  }

  String? _getErrorText(String label, String value) {
    if (value.isEmpty) return null;
    
    final number = int.tryParse(value);
    if (number == null) return "Invalid number";
    if (number < 0) return "Cannot be negative";
    
    if (label == "Hours" && number >= 24) return "Max 23 hours";
    if (label == "Minutes" && number >= 60) return "Max 59 minutes";
    
    return null;
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
                        "Event will end: ${endTime.toLocal().toString().split(".")[0]}",
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
            onChanged: (value) => _validateAndUpdate(),
          ),
        ],
      ),
    );
  }
}