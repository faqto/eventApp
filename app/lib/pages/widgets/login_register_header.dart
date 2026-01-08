import 'package:flutter/material.dart';

class LoginRegisterHeader extends StatelessWidget {
  final String subtitle;
  const LoginRegisterHeader({
    super.key, 
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/images/asata_logo.png',  
          ),
          SizedBox(height: 10,),
            Text(
              subtitle,
              style: TextStyle(
              fontSize: 28,
              color: Colors.black87,
              fontWeight: FontWeight.bold
              ),
            ), 
        ],
      ),
    );
  }
}
