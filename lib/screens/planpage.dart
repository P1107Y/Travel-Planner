import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mp5/services/currency_converter.dart';
import 'package:mp5/services/dbhelper.dart';

class PlanPage extends StatefulWidget {
  final String destination_city;
  final String budget;
  final String home_country;

  PlanPage(
      {required this.destination_city,
      required this.budget,
      required this.home_country});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  Map<String, dynamic> jsonData = {};
  String budget = "";
  String destination_city = "";
  Map<String, dynamic>? cityCosts;
  CurrencyConverter currencyConverter = new CurrencyConverter();
  Map<String, dynamic> currencyData = {};
  Map<String, bool> isPossible = {};
  double convertedCurrency = 0;
  String convertedCurrencyType = "";
  List<Plans> saved_plans = [];
  int count_plans = 0;
  final DBHelper dbHelper = DBHelper();
  @override
  void initState() {
    super.initState();
    // Load JSON data when the widget is first created
    budget = widget.budget;
    destination_city = widget.destination_city;
    loadJsonData();
    convertCurrency();
    print(isPossible);
  }

  double getNumericValue(String budget) {
    // Extract numeric part and remove commas
    String numericPart = budget.replaceAll(RegExp(r'[^0-9.]'), '');

    // Convert to double
    return double.parse(numericPart);
  }

  Future<String> convertCurrency() async {
    currencyData = await currencyConverter.getCurrencyExchangeRates();
    print(cityCosts);
    List<dynamic> firstThreeLetters =
        cityCosts!.values.map((value) => value.substring(0, 3)).toList();
    convertedCurrencyType = firstThreeLetters[0];
    String givenCurrencyType = widget.budget.substring(0, 3);
    var givenConverter = currencyData["data"][givenCurrencyType]["value"];
    var expectedConverter =
        currencyData["data"][convertedCurrencyType]["value"];

    double numericValue = getNumericValue(widget.budget);
    givenConverter =
        givenCurrencyType != "USD" ? 1 / givenConverter : givenConverter;
    convertedCurrency = (numericValue * givenConverter * expectedConverter);
    Map<String, double> numericValuesMap = cityCosts!.map((key, value) {
      // Extract numeric part and remove commas
      String numericPart = value.replaceAll(RegExp(r'[^0-9.]'), '');

      // Convert to double
      double numericValue = double.parse(numericPart);

      return MapEntry(key, numericValue);
    });
    print(numericValuesMap);
    setState(() {
      isPossible = numericValuesMap.map((key, value) {
        bool isGreater = value < convertedCurrency;
        return MapEntry(key, isGreater);
      });
    });

    print(isPossible);
    convertedCurrency = double.parse(convertedCurrency.toStringAsFixed(2));
    return convertedCurrency.toString();
  }

  Future<void> loadJsonData() async {
    try {
      // Load JSON data from assets
      String jsonString = await rootBundle.loadString('assets/data.json');
      List<Plans> data = await dbHelper.getPlans();
      int count = await dbHelper.getPlansCount();
      // Parse the JSON data and update the state
      setState(() {
        jsonData = json.decode(jsonString);

        // Extract costs for the destination city
        cityCosts = jsonData['cities'].firstWhere(
          (city) => city['name'] == destination_city,
          orElse: () => null,
        )?['costs'];
        count_plans = count;
        saved_plans = data;
      });
    } catch (e) {
      print('Error reading JSON file: $e');
      // Handle error, maybe show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Plan"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
              "Budget $budget is is equivalent to $convertedCurrencyType $convertedCurrency"),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
                "So, Number of days possible to stay in $destination_city with budget $budget is/are"),
          ),
          Column(
            children: isPossible.entries.map((entry) {
              if (entry.value) {
                return ListTile(
                  title: Center(
                    child: Text(
                      "Average amount required for ${entry.key} is ${cityCosts![entry.key]}",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                );
              } else {
                return Container(); // Empty container for cities where the budget is not possible
              }
            }).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (cityCosts != null) {
                // Access costs based on your needs
                dbHelper.insertPlans(Plans(
                    id: count_plans + 1,
                    home_country: widget.home_country,
                    destination_city: widget.destination_city,
                    budget: widget.budget,
                    plan_possible:
                        isPossible.values.contains(true) ? "True" : "False"));
              }
            },
            child: Text("Save Plan"),
          ),
        ],
      ),
    );
  }
}
