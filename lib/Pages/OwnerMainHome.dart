import 'package:click_gujrat/Pages/Discover.dart';
import 'package:click_gujrat/Pages/OwnerHome.dart';
import 'package:click_gujrat/Pages/Profile.dart';
import 'package:click_gujrat/Pages/Setting.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/Widgets/icon_and_text.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';

import 'owner_discover.dart';
class OwnerMainHome extends StatefulWidget {
  const OwnerMainHome({Key? key}) : super(key: key);

  @override
  _OwnerMainHomeState createState() => _OwnerMainHomeState();
}

class _OwnerMainHomeState extends State<OwnerMainHome> {
  late List<Widget> _pages;
  late Widget _home;
  late Widget _discover;
  late Widget _profile;
  late Widget _setting;
  late int _currentIndex;
  late Widget _currentPage;
  @override
  void initState() {
    super.initState();
    _home = const OwnerHome();
    _discover = const OwnerDiscover();
    _profile= const MyProfile();
    _setting=const MySettings();
    _pages = [_home, _discover,_setting,_profile];
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
        items: [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label:'Discover',
            icon: Icon(Icons.compass_calibration),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: Icon(Icons.settings),
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
