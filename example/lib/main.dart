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
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(phoneNumber ?? "Type"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PhoneField(
                  isEnabled: false,
                  initialPhoneNumber: "+9779817194337",
                  onChanged: (p0) {
                    phoneNumber = p0.phoneNumberWithCode;
                    setState(() {});
                  },
                ),
              ),
              FilledButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    var phone = await PhoneField.getPhoneNumber("+16465006465");
                    if (phone != null && phone.isValid == false) {
                      print(phone.message);
                      return;
                    }
                    print("Success");
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
