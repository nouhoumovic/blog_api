//------- EndPoint

import 'package:flutter/material.dart';

const baseUrl = 'http://127.0.0.1:8000/api';
// ignore: prefer_interpolation_to_compose_strings
const loginURL = baseUrl + '/login';
const registerURL = baseUrl + '/register';
const logoutURL = baseUrl + '/logout';
const userURL = baseUrl + '/user';
const postsURL = baseUrl + '/posts';
const commentsURL = baseUrl + '/comments';


// Error
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong,try again';

//------- input decoration

InputDecoration kInputDecoration(String label){
  return InputDecoration (
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(borderSide: BorderSide(width: 1,color:Colors.white54 ),),
  );
}

TextButton kTextButton(String label, Function onPressed){
  return  TextButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10)),
    ),
    onPressed: ()=> onPressed(),
    child: Text(label, style : const TextStyle(color: Colors.white),),
  );
}

Row kLoginRegisterHint(String text,String label,Function onTap ){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label,style: TextStyle(color: Colors.blue),),
        onTap:()=> onTap() ,
      )
    ],
  );
}

Expanded kLikeAndComment (int value,IconData icon, Color color, Function onTap){
 return Expanded(
        child: Material(
          child: InkWell(
            onTap: ()=>onTap(),
            child:Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,size: 16,color: color,),
                  SizedBox(width: 4),
                  Text('$value')
                ],
                ),
              ),
          ),
        ) 
        );
}