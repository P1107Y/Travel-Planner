import 'package:flutter/material.dart';
import 'package:mp5/services/dbhelper.dart';

class PlannedList extends StatefulWidget {
  final List<Plans> plans;
  const PlannedList({required this.plans});

  @override
  State<PlannedList> createState() => _PlannedListState();
}

class _PlannedListState extends State<PlannedList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My plans")),
      body: Container(
        child: ListView.builder(
          itemCount: widget.plans.length,
          itemBuilder: (context, index) {
            // Customize this part based on your Plans class structure
            final plan = widget.plans[index];
            String customString =
                (plan.plan_possible == "True") ? 'possible' : 'not possible';

            return ListTile(
              title: Text("${plan.home_country} -> ${plan.destination_city}"),
              subtitle:
                  Text('With the budget ${plan.budget} trip is $customString'),

              // Add more details if needed
            );
          },
        ),
      ),
    );
  }
}
