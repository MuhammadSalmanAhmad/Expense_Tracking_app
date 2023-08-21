
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainPanel extends StatefulWidget {
  const MainPanel({super.key});

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  //FIREBASE REFERENCES AND INTANCE FOR REALTIME DATABASE AND AUTH
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  late var username = user?.uid;
  var data = " ";

  final DatabaseReference reference = FirebaseDatabase.instance.ref('Users/');
  late final DatabaseReference expense_reference =
      FirebaseDatabase.instance.ref('Expenses/$username');

  // VARIABLES OG GETTING AMOUNTS AND CATEGORIES FROM THE DATABASE AND TOTAL EXPENSE

  var total_expense = 0;
  Map Expensedata = {};
  List<int> amounts = [];
  List<String> categories = [];

  // function for getting chart data

  

  ///iN THIS INIT STATE WE ARE GETTING VALUES OF DIFFERENT DATA POINTS FROM THE FIREBASE DATABASE AND STORING THEM IN A LIST
  ///AND THEN USING THAT LIST TO DISPLAY THE CHART

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    expense_reference.onChildAdded.listen((event) {
      var snapshot = event.snapshot;

      setState(() {
        Expensedata = snapshot.value as Map<dynamic, dynamic>;
        amounts.add(int.tryParse(snapshot.child('amount').value.toString())!);
        categories.add(snapshot.child('category').value.toString());
      });
      print(Expensedata);
      for (var i in Expensedata.keys) {
        if (i == 'amount') {
          setState(() {
            total_expense = total_expense +
                double.tryParse(snapshot.child('amount').value.toString())!
                    .toInt();
          });
        }
      }
      print(total_expense);
    });
  }

  @override
  Widget build(BuildContext context) {



  List<ExpenseData> getData() {
    List<ExpenseData> data = [];
    for (int i = 0; i < amounts.length; i++) {
      data.add(ExpenseData(categories[i], amounts[i]));
    }
    return data;
  }
late List<ExpenseData> chartdata = getData();
    reference.child('$username/name').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        data = snapshot.value.toString();
      });
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Welcome $data",
            style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: const Color(0xff607D8B)),
          ),
          Container(
            child: SfCircularChart(
              series: <CircularSeries>[
                PieSeries<ExpenseData, String>(
                  dataSource: chartdata,
                  dataLabelMapper:(ExpenseData data, _) => data.category ,
                  xValueMapper: (ExpenseData data, _) => data.category,
                  yValueMapper: (ExpenseData data, _) => data.amount/total_expense*100 ,
              
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside),
                )
              ],
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: expense_reference,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return ListTile(
                        subtitle: Text(snapshot.child('Date').value.toString()),
                        title:
                            Text(snapshot.child('category').value.toString()),
                        trailing: Text(
                            "\$" + snapshot.child('amount').value.toString()));
                  }))
        ],
      ),
    );
  }
}

class ExpenseData {
  late final String category;
  late final int amount;

  ExpenseData(
    this.category,
    this.amount,
  );
}
