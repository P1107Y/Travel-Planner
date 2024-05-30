import 'package:flutter/material.dart';
import 'package:mp5/screens/destinationpage.dart';
import 'package:mp5/screens/planned_list.dart';
import 'package:mp5/utils/constants.dart';
import 'package:mp5/services/dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController citynameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String home_country = "";
  String budget = "";
  String numberOfDays = "1";
  String selectedCurrency = "USD";
  List<Plans> saved_plans = [];
  final DBHelper dbHelper = DBHelper();
  @override
  void initState() {
    super.initState();
    getplans();
  }

  Future<void> getplans() async {
    var plans = await dbHelper.getPlans();
    setState(() {
      saved_plans = plans;
      print(saved_plans);
    });
  }

  @override
  void dispose() {
    citynameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _next() async {
    home_country = citynameController.text;
    budget = amountController.text;
    if (home_country != "" && budget != "") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DestinationPage(
          budget: "$selectedCurrency $budget",
          home_country: home_country,
        );
      }));
    } else
      null;
  }

  void _plans() async {
    getplans();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlannedList(plans: saved_plans);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Planner'),
        actions: [
          IconButton(onPressed: _plans, icon: Icon(Icons.airplanemode_active))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Traveller Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: citynameController,
              decoration: InputDecoration(labelText: 'Enter Home Country'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Enter Travel budget'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  'Select Currency',
                  textAlign: TextAlign.center,
                )),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCurrency = newValue!;
                      });
                    },
                    items: kCurrencySymbol
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _next,
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
