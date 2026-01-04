import 'package:flutter/material.dart';
import 'package:app/models/buttons_model.dart';

class ButtonActionList extends StatelessWidget {
  final List<ButtonAction> actions;

  const ButtonActionList({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: action.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: action.color,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                action.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
