import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Pages/Home/main_home.dart';
import 'package:click_gujrat/Pages/Login.dart';
import 'package:click_gujrat/Pages/OwnerMainHome.dart';
import 'package:click_gujrat/Pages/admin/admin_home.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';


import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //return either home or authentication
    final firebaseUser = Provider.of<UserModel?>(context);
    if (firebaseUser == null) {
      return const MyLogin();
    } else {
      return FutureBuilder<int>(
        future: getRole(),
        builder: (context, snapshot) {
          if (snapshot.data == 1) {
            return const OwnerMainHome();
          } else if (snapshot.data == 3){
            return const AdminHomePage();
          } else if (snapshot.data == 2){
            return const MainHome();
          }else {
            return Scaffold(
              body: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                  SizedBox(height: 10,),
                  Text('Loading...')
                ],
              )),
            );
          }
        },
      );
    }
  }

  Future<int> getRole() async {
    final _user = await AuthService().getUserInfo();
    Roles.roles = _user.role;
    return _user.role;
  }
}
