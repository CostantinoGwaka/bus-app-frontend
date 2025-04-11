import 'package:app/provider/app_data_provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({super.key});

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  String? fromCity, toCity;
  DateTime? departure;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                DropdownButtonFormField<String>(
                  value: fromCity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  hint: const Text('From'),
                  isExpanded: true,
                  items:
                      cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      fromCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: toCity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  hint: const Text('To'),
                  isExpanded: true,
                  items:
                      cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      toCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _selectedDate,
                        child: Text('Select Departure Date'),
                      ),
                      Text(
                        departure == null
                            ? 'No Date Chosen'
                            : getFormattedDate(
                              departure!,
                              pattern: 'EEE MMM dd, yyyy',
                            ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _search,
                      child: Text("SEARCH"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectedDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (selectedDate != null) {
      setState(() {
        departure = selectedDate;
      });
    }
  }

  void _search() {
    if (departure == null) {
      showMsg(context, emptyDateErrMessage);
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (fromCity == toCity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('From and To cities cannot be the same'),
          ),
        );
      } else {
        Provider.of<AppDataProvider>(
          context,
          listen: false,
        ).getRouteByCityFromAndCityTo(fromCity!, toCity!).then((route) {
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            routeNameSearchResultPage,
            arguments: [route, getFormattedDate(departure!)],
          );
        });
      }
    }
  }
}
