import 'package:blog/constant.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/user_model.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/views/auth/login.dart';
import 'package:blog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> fromkey =GlobalKey<FormState>();
  bool loading = false;

  TextEditingController nameController= TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  void _registerUser() async {
    ApiResponse response = await registreUser(nameController.text,emailController.text, passwordController.text);

    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      loading =false;
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
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: fromkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Name is empty' : null,
                decoration:kInputDecoration("Name")
            ),
            const SizedBox(height: 10,),
            TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration:kInputDecoration("Email")
            ),
            const SizedBox(height: 10,),
            TextFormField(
                controller: passwordController,
                obscureText: false,
                validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration:kInputDecoration("Password")

            ),
            const SizedBox(height: 10,),
            TextFormField(
                controller: passwordConfirmController,
                obscureText: false,
                validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration:kInputDecoration("Password Confirmation")
            ),
            const SizedBox(height: 10,),
            loading? const Center(child: CircularProgressIndicator(),)
                :
            kTextButton("Register", (){
              if(fromkey.currentState!.validate()){
                setState(() {
                  loading= !loading;
                  _registerUser();
                });
              }
            }),
            const SizedBox(height: 10,),
            kLoginRegisterHint("You have an account? ", "Login",
                  (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
