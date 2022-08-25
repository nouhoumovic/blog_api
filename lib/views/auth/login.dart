import 'package:blog/constant.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/user_model.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/views/auth/register.dart';
import 'package:blog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> fromkey =GlobalKey<FormState>();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool loading =false;
  void _loginUser() async {
    ApiResponse response = await login(textEmail.text, textPassword.text);

    if(response.error == null){
    _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
         loading =false;
      });
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  void _saveAndRedirectToHome(User user) async{
  SharedPreferences pref =  await SharedPreferences.getInstance();

  pref.setString("token", user.token ?? "");
  pref.setInt("userId", user.id ?? 0);
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text('Login'),
       centerTitle: true,
     ),
      body: Form(
        key: fromkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              controller: textEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration:kInputDecoration("Email")
            ),
            const SizedBox(height: 10,),
            TextFormField(
                controller: textPassword,
                obscureText: false,
                validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration:kInputDecoration("Password")
            ),
            const SizedBox(height: 10,),
            loading? const Center(child: CircularProgressIndicator(),)
            :
            kTextButton("Login", (){
                if(fromkey.currentState!.validate()){
                  setState(() {
                    loading = true;
                    _loginUser();
                  });
                }
            }),
            const SizedBox(height: 10,),
            kLoginRegisterHint("Dont have an account? ", "Register",
                    (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Register()), (route) => false);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
