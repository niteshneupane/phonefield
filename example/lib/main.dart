import 'package:flutter/material.dart';
import 'package:phonefield/phonefield.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(phoneNumber ?? "Type"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhoneField(
            // initialPhoneNumber: "+9779817194337",
            initialPhoneNumber: "+17785554321",

            phoneNumber: (p0) {
              phoneNumber = p0.phoneNumber;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
