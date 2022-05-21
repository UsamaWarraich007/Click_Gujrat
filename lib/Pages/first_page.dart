import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Wrapper.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber
              ),
              child: TextButton(onPressed: () {
                Roles.roles=1;
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Wrapper()));
              }, child: const Text('SignIn With Owner')),
            ),
          ),

          Center(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber
              ),
              child:TextButton(onPressed: () {
                Roles.roles=2;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Wrapper()));
              }, child: const Text('SignIn With User')),
            ),
          ),
        ],
      ),
    );
  }
}
