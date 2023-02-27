import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget editBox({
  required bool isPassword,
  required String text,
  IconData? suffixIcon,
  IconData? prefixIcon,
  TextInputType? type,
  Function()? function,
  var controller,
}) =>
    TextFormField(
      keyboardType: type,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "${text} can't be empty";
        }
        return null;
      },
      obscureText: isPassword,
      decoration: InputDecoration(
          label: Text(text),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: IconButton(onPressed: function, icon: Icon(suffixIcon)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    );

Widget defaultButton(
  context, {
  required String text,
  Color? backgroundcolor,
  Color? textcolor,
  Function()? function,
}) =>
    Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 13,
        child: MaterialButton(
          color: backgroundcolor == null ? Colors.black : backgroundcolor,
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(
              color: textcolor == null ? Colors.white : textcolor,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
    );

Future<bool?> toast({
  required String message,
  Color? color,
}) =>
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color == null ? Colors.green : color,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
