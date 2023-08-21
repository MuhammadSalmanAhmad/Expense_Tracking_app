import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  // firebase auth and firbase databse instances and references are being called and set

  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Expenses/");
  DatabaseReference ref1 = FirebaseDatabase.instance.ref("Income/");

  // variables for the dropdown button and date picker

  DateTime selectedDate = DateTime.now();
  String default_dropdown_value = "Food";
  final ExpenseController = TextEditingController();
  final AmountController = TextEditingController();
  void item_selected(String? value) {
    if (mounted) {
      setState(() {
        default_dropdown_value = value!;
      });
    }
  }

  Future<DateTime?> ShowDateTimePicker() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (newDate != null) {
      if (mounted) {
        setState(() {
          selectedDate = newDate;
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/salary.png"),
            )),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select Expense Category :",
                style: GoogleFonts.abel(
                    color: const Color(0xff088395),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xff088395),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_circle_rounded),
                  iconSize: 20,
                  items: const [
                    DropdownMenuItem(
                        value: "Food",
                        child: Text(
                          "Food",
                          style: TextStyle(color: Colors.white),
                        )),
                    DropdownMenuItem(
                        value: "Travel",
                        child: Text(
                          "Travel",
                          style: TextStyle(color: Colors.white),
                        )),
                    DropdownMenuItem(
                        value: "Shopping",
                        child: Text(
                          "Shopping",
                          style: TextStyle(color: Colors.white),
                        )),
                    DropdownMenuItem(
                        value: "Grocerry",
                        child: Text(
                          "Grocerry",
                          style: TextStyle(color: Colors.white),
                        )),
                    DropdownMenuItem(
                        value: "Entertainment",
                        child: Text(
                          "entertainment",
                          style: TextStyle(color: Colors.white),
                        )),
                    DropdownMenuItem(
                        value: "Fuel",
                        child: Text(
                          "Fuel",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                  onChanged: item_selected,
                  value: default_dropdown_value,
                  focusColor: const Color(0xff088395),
                  dropdownColor: const Color(0xff088395),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: ExpenseController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: "Enter Amount"),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select Date :",
                style: GoogleFonts.abel(
                    color: const Color(0xff088395),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  onPressed: ShowDateTimePicker,
                  child: const Text("choose date")),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: AmountController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: "Enter Income"),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                backgroundColor: const Color(0xff088395),
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () async {
                debugPrint(user!.uid);
                DatabaseReference realref = ref.child(user!.uid).push();
                await realref.set({
                  "category": default_dropdown_value,
                  "amount": ExpenseController.text.toString(),
                  "Date": selectedDate.toString(),
                });
                await ref1.child(user!.uid).set({
                  "amount": AmountController.text.toString(),
                });
              },
              child: Text(
                "SAVE",
                style:
                    GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
