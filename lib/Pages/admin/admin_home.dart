import 'package:click_gujrat/Pages/OwnerHome.dart';
import 'package:click_gujrat/Pages/Setting.dart';
import 'package:click_gujrat/Pages/admin/admin_home_tab.dart';
import 'package:flutter/material.dart';

import '../Discover.dart';
import '../Profile.dart';
import 'admin_discover.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late List<Widget> _pages;
  late Widget _home;
  late Widget _discover;
  late Widget _profile;
  late int _currentIndex;
  late Widget _currentPage;
  @override
  void initState() {
    super.initState();
    _home = const AdminHomeTab();
    _discover = const Discover();
    _profile= const MyProfile();
    _pages = [_home, _discover, _profile];
    _currentIndex = 0;
    _currentPage = _home;
  }
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black38,
        selectedFontSize: 20,
        unselectedFontSize: 18,
        onTap: (value) {
          //  print(value);
          _changeTab(value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label:'Discover',
            icon: Icon(Icons.compass_calibration),
          ),

          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
