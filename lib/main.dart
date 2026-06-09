import 'package:flutter/material.dart';

void main() {
  runApp(const ALUConnectApp());
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('ALU Connect')),
      ),
    );
  }
}
