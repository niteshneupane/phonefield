import 'package:flutter/material.dart';
import 'package:phonefield/country_code_picker.dart';

import 'countries_model.dart';
import 'custom_text_field.dart';

class CountryListPickerPage extends StatefulWidget {
  const CountryListPickerPage({super.key, required this.args});

  @override
  State<CountryListPickerPage> createState() => _CountryListPickerPageState();

  final CountryListPickerPageArgs args;
}

class _CountryListPickerPageState extends State<CountryListPickerPage> {
  late List<CountriesModel> filteredCountryList;

  @override
  void initState() {
    super.initState();
    filteredCountryList = widget.args.countriesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Code"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: CustomTextField(
              hintText: "Search Country",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.close),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              onChanged: (value) {
                setState(() {
                  filteredCountryList = widget.args.countriesList.filter(value);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xffCBD5E1),
              ),
              itemCount: filteredCountryList.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemBuilder: (context, index) {
                CountriesModel model = filteredCountryList[index];
                return InkWell(
                  onTap: () {
                    widget.args.selectedCountry.value = model;
                    widget.args.onPicked.call(model);
                    Navigator.of(context).pop();
                    // args.selectedCountry.value = model;
                    // args.onPicked.call(model);
                    // context.pop();
                  },
                  child: Row(
                    children: [
                      Text(
                        model.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: Text(model.name)),
                      Text(
                        model.dialCode,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
