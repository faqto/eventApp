import 'package:flutter/material.dart';

class ModifyDurationSection extends StatefulWidget {
  final Duration initialDuration;
  final Function(Duration) onDurationChanged;

  const ModifyDurationSection({
    super.key,
    required this.initialDuration,
    required this.onDurationChanged,
  });

  @override
  State<ModifyDurationSection> createState() => _ModifyDurationSectionState();
}

class _ModifyDurationSectionState extends State<ModifyDurationSection> {
  late TextEditingController _daysController;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    final totalMinutes = widget.initialDuration.inMinutes;
    final days = totalMinutes ~/ (24 * 60);
    final hours = (totalMinutes % (24 * 60)) ~/ 60;
    final minutes = totalMinutes % 60;

    _daysController = TextEditingController(text: days.toString());
    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
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

    final totalDuration = Duration(
      days: days,
      hours: hours,
      minutes: minutes,
    );

    if (totalDuration.inMinutes > 0) {
      widget.onDurationChanged(totalDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "Event Duration",
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
                borderSide: BorderSide(color: const Color(0xFF7F5DFB)),
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

  //fixed duration
  String? _getErrorText(String label, String value) {
    if (value.isEmpty) return null;
    
    final number = int.tryParse(value);
    if (number == null) return "Invalid number";
    if (number < 0) return "Cannot be negative";
    
    if (label == "Hours" && number >= 24) return "Max 23 hours";
    if (label == "Minutes" && number >= 60) return "Max 59 minutes";
    
    return null;
  }
}