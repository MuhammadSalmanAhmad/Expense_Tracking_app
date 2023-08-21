
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utilities{
 void show_Message(var message){
  
  Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 76, 98, 109),
        textColor: Colors.white,
        fontSize: 16.0
    );
}
}