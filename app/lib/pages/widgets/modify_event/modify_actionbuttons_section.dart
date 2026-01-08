import 'package:flutter/material.dart';

class ModifyActionButtonsSection extends StatelessWidget {
  final Function onSave;
  final Function onCancelEvent;
  final bool isSaveEnabled;

  const ModifyActionButtonsSection({
    super.key,
    required this.onSave,
    required this.onCancelEvent,
    this.isSaveEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isSaveEnabled ? () => onSave() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F5DFB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onCancelEvent(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red.shade400),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Cancel Event",
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}