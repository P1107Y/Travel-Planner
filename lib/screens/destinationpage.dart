import 'package:flutter/material.dart';
import 'package:mp5/screens/planpage.dart';
import 'package:mp5/utils/constants.dart';

class DestinationPage extends StatefulWidget {
  final String budget;
  final String home_country;

  DestinationPage({required this.budget, required this.home_country});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  late String budget;
  late String home_country;
  @override
  void initState() {
    super.initState();
    // No need for a separate method, you can directly initialize the variable here
    budget = widget.budget;
    home_country = widget.home_country;
    print(budget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Select Destination"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        children: List.generate(
          kCities.length,
          (index) {
            return GestureDetector(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PlanPage(
                    destination_city: kCities[index],
                    budget: budget, // Pass the budget variable here
                    home_country: home_country,
                  );
                }));
              },
              child: Center(
                child: Text(
                  kCities[index],
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
