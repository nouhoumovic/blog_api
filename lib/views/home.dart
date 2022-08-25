import 'package:blog/services/user_service.dart';
import 'package:blog/views/auth/login.dart';
import 'package:blog/views/post/post_form.dart';
import 'package:blog/views/post/post_screen.dart';
import 'package:blog/views/profile/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text("Blog App"),
       actions: [
         IconButton(
           onPressed: (){
             logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false),
                });
         },
        icon: const Icon(Icons.exit_to_app))
       ],
     ),
     body: currentIndex == 0 ? PostScreen() : Profile(),
     floatingActionButton: FloatingActionButton(
       onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>PostForm(title: 'Add Post',)), (route) => false);
     },
     child: const Icon(Icons.add),
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     bottomNavigationBar: BottomAppBar(
       notchMargin: 5,
       elevation: 10,
       clipBehavior: Clip.antiAlias,
       shape: CircularNotchedRectangle(),
       child: BottomNavigationBar(
         items: [
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label: '',
             ),
          BottomNavigationBarItem(
            icon:Icon(Icons.person),
            label: '',
             ),
         ],
         currentIndex: currentIndex,
         onTap: (val){
            setState(() {
           currentIndex =val;
          });
         }
         ),
         ),
    );
  }
}
