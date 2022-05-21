import 'package:click_gujrat/Pages/Discover.dart';
import 'package:click_gujrat/Pages/Home/main_home.dart';
import 'package:click_gujrat/Pages/Login.dart';
import 'package:click_gujrat/Pages/OwnerHome.dart';
import 'package:click_gujrat/Pages/Profile.dart';
import 'package:click_gujrat/Pages/SignUp.dart';
import 'package:click_gujrat/Pages/admin/admin_home.dart';
import 'package:click_gujrat/Pages/costum_search.dart';
import 'package:click_gujrat/Pages/first_page.dart';
import 'package:click_gujrat/Pages/map/add_location.dart';
import 'package:click_gujrat/Wrapper.dart';
import 'package:click_gujrat/routes/routes.dart';
import 'package:get/get.dart';

import '../Pages/AddPlace.dart';
import '../Pages/ContactUs.dart';
import '../Pages/Setting.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.addPlace, page: () => const AddPlace()),
    GetPage(name: AppRoutes.contactPage, page: () => const ContactPage()),
    GetPage(name: AppRoutes.customSearch, page: () => const CustomSearchScreen()),
    GetPage(name: AppRoutes.login, page: () => const MyLogin()),
    GetPage(name: AppRoutes.signUp, page: () => const MySignUp()),
    GetPage(name: AppRoutes.profile, page: () => const MyProfile()),
    GetPage(name: AppRoutes.discover, page: () => const Discover()),
    GetPage(name: AppRoutes.firstPage, page: () => const FirstPage()),
    GetPage(name: AppRoutes.ownerHome, page: () => const OwnerHome()),
    GetPage(name: AppRoutes.settings, page: () => const MySettings()),
    GetPage(name: AppRoutes.addLocation, page: () => const AddLocation()),
    GetPage(name: AppRoutes.mainHome, page: () => const MainHome()),
    GetPage(name: AppRoutes.adminHome, page: () => const AdminHomePage()),
    GetPage(name: AppRoutes.wrapper, page: () => const Wrapper()),
  ];
}