import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class SmsWidget extends StatefulWidget {
  const SmsWidget({Key? key}) : super(key: key);

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  late String sms = "Your messages will be displayed here";

  final Telephony telephony = Telephony.instance;
  List<SmsMessage> _messages = [];

  //keywords list defines that can be part of a sms

  final List<String> Entertainment = ['Theatre', 'film', 'ice-skating'];
  final List<String> Food = [
    'KFC',
    'restaurant',
    'STARBUCKS',
    'TEA',
    'CAFE',
    'PASTRY'
  ];
  final List<String> Health = [
    'hospital',
    'doctor',
    'pharmacy',
    'medicine',
    'clinic',
    'labaoratory'
  ];
  final List<String> Shopping = [
    'shop',
    'mall',
    'market',
    'store',
    'supermarket',
    'mart',
    'Boutique',
    'clothing'
  ];

  late String category = 'not defined';

  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Expenses/");

  List<String> testbodylist = [];

  @override
  initState() {
    super.initState();
    // _getSmsMessages();
    if (mounted) {
      setState(() {
        _getSmsMessages();
      });
    }
  }

  Future<void> _getSmsMessages() async {
    if (await Permission.sms.status.isDenied) {
      await Permission.sms.request();
    }
    if (await Permission.sms.status.isGranted) {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      debugPrint("Permissions granted: $permissionsGranted");
      List<SmsMessage> messages = await telephony.getInboxSms(
        // columns: [SmsColumn.ID, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE ],
        // sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      print("Number of Messages Read from Phone ${messages.length}");
      print("Data of Messages 1 Read ${messages[0].read}");
      print("Data of Messages 1 Read ${messages[0].read}");

      // print(messages[0].date.toString());
      _messages = messages;

      String? testbody = messages[0].body;

      debugPrint(_messages[0].body.toString());

      testbodylist = testbody!.split(" ");
      debugPrint(testbodylist.toString());

     for (int i = 0; i < testbodylist.length; i++) {
    debugPrint(testbodylist[i]);
    if (Entertainment.contains(testbodylist[i])) {
        debugPrint("Entertainment");
        category = 'Entertainment';
        break;
    } else if (Food.contains(testbodylist[i])) {
        debugPrint("Food");
        category = 'Food';
        break;
    } else if (Health.contains(testbodylist[i])) {
        debugPrint("Health");
        category = 'Health';
        break;
    } else if (Shopping.contains(testbodylist[i])) {
        debugPrint("Shopping");
        category = 'Shopping';
        break;
    } else {
        debugPrint("not defined");
        category = 'others';
        // You can choose whether to break here or not, depending on your desired behavior
    }
}

      // setState(() {
      //   _messages = messages;
      // });
    } else {
      // Handle permission denied
      print("Permission to read SMS messages is denied.");
    }
  }

  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   if (mounted) {
  //     telephony.listenIncomingSms(
  //         onNewMessage: (SmsMessage message) {
  //           setState(() {
  //             sms = message.body!;
  //           });
  //         },
  //         listenInBackground: false);
  //     super.setState(fn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  DatabaseReference realref = ref.child(user!.uid).push();
                  await realref.set({
                    "category": category,
                    "amount": testbodylist[3],
                    "Date": DateTime.now().toString(),
                  });
                },
                child: const Text('get sms')),
          ),
          Text(sms),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int i) {
                var message = _messages[i];

                return ListTile(
                  title: Text('${message.address} [${message.date}]'),
                  subtitle: Text('${message.body}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
