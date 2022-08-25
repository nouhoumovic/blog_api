import 'dart:io';

import 'package:blog/constant.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String title;

  PostForm({this.post, required this.title});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> formkey =GlobalKey<FormState>();
  bool loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ?null : getStringImage(_imageFile);

    ApiResponse response = await createPost(txtControllerBody.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    }else if(response.error == unauthorized){
      logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false),
                });
    }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));

       setState(() {
         loading =!loading;
       });
    }
  }

   // edit post
  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, txtControllerBody.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
      setState(() {
        loading = !loading;
      });
    }
  }
  @override
  void initState() {
    if(widget.post != null){
      txtControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }
  final picker = ImagePicker();
  TextEditingController txtControllerBody= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("${widget.title}"),
      ),
      body: 
       loading? const Center(child: CircularProgressIndicator(),)
            : ListView(
        children: [
          widget.post != null ? const SizedBox() : 
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: _imageFile == null ? null : DecorationImage(image: FileImage(_imageFile ?? File("")),
              )
            ),
            child: Center(
              child: IconButton(
                onPressed: (){
                  getImage();
              }, icon: Icon(Icons.image, size: 50,color: Colors.black38)),
            ),
          ),
          Form(
            key: formkey,
            child: Padding(
              padding:EdgeInsets.all(8),
              child: TextFormField(
                controller: txtControllerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val)=> val!.isEmpty ? 'Post body is required' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black38))
                ),
              ), 
              ), 
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton("Post", (){
             if(formkey.currentState!.validate()){
                setState(() {
                loading =!loading;
              });
              if(widget.post == null ){
                _createPost();
              }else{
                    _editPost(widget.post!.id ?? 0);
              }
             
             }
            }),)
        ]),
    );
  }
}