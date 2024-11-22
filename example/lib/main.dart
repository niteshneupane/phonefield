import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phonefield/phonefield.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCountry = useState<({String name, String code})?>(null);
    final selectedState = useState<String?>(null);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PhoneField(
                  // isEnabled: false,
                  initialPhoneNumber: "+9779817194337",
                  onChanged: (p0) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryPicker(
                  labelText: "Country",
                  hintText: "Select a country",
                  selectedCountry: selectedCountry,
                  onChanged: (p0) {
                    selectedState.value = null;
                  },
                  validator: (p0) {
                    if (p0 == null) {
                      return "Please select country ";
                    }
                    return null;
                  },
                  // onSelected: (v) {
                  //   selectedCountry = v;
                  //   setState(() {});
                  // },
                  // onSelect: (p0) {
                  //   selectedCountry = p0;
                  //   setState(() {});
                  //   stateController.clear();
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StatePicker(
                  // labelText: "State",
                  enabled: selectedCountry.value != null,
                  hintText: "Select a state",
                  countryCode: selectedCountry.value?.code,
                  selectedState: selectedState,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return selectedCountry.value != null
                          ? "Please select state"
                          : "Please select country first and select state";
                    }
                    return null;
                  },
                ),
              ),
              ValueListenableBuilder<({String code, String name})?>(
                  valueListenable: selectedCountry,
                  builder: (context, country, child) {
                    return Text("Selected Country = ${country?.name}");
                  }),
              Text("Selected State = $selectedState"),
              FilledButton(
                onPressed: () async {
                  selectedCountry.value = null;
                },
                child: const Text("Clear Country"),
              ),
              FilledButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    var phone = await PhoneField.getPhoneNumber("+16465006465");
                    if (phone != null && phone.isValid == false) {
                      log(phone.message.toString());
                      return;
                    }
                    log("Success");
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
