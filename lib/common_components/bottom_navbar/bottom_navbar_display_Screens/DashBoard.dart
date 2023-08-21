import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPanel extends StatefulWidget {
  const MainPanel({super.key});

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  late var username = user?.uid;
  var data = " ";

  final DatabaseReference reference = FirebaseDatabase.instance.ref('Users/');
  late final DatabaseReference expense_reference =
      FirebaseDatabase.instance.ref('Expenses/$username');
  var total_expense = 0;
  Map Expensedata = {};
  @override
  void initState() {
    // TODO: implement initState
    expense_reference.onChildAdded.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        Expensedata = snapshot.value as Map<dynamic, dynamic>;
      });
      print(Expensedata);
      for (var i in Expensedata.keys) {
          if(i=='amount'){
          
            setState(() {
              total_expense = total_expense + double.tryParse(snapshot.child('amount').value.toString())!.toInt();
            });
            
          }
        
      }
      print(total_expense);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
              child: FirebaseAnimatedList(
                  query: expense_reference,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return ListTile(
                      subtitle: Text(snapshot.child('Date').value.toString()),
                        title:
                            Text(snapshot.child('category').value.toString()),
                        trailing:
                            Text("\$"+snapshot.child('amount').value.toString()));
                  }))
        ],
      ),
    );
  }
}
