import 'package:click_gujrat/Models/place_model.dart';
import 'package:click_gujrat/Pages/AddPlace.dart';
import 'package:click_gujrat/Pages/first_page.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Services/comments_service.dart';
import 'package:click_gujrat/Services/likes_comments.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Wrapper.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'Models/User.dart';
import 'Services/app_services.dart';
import 'routes/pages.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
 // WidgetsFlutterBinding.ensureInitialized();
  await AppServices().initServices();
  if (kReleaseMode) {
    Get.isLogEnable = false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        Provider<AuthService>(create: (_)=> AuthService()),
        Provider<LikesComments>(create: (_)=> LikesComments()),
        StreamProvider<UserModel?>.value(value: AuthService().user, initialData: null,),
        StreamProvider<User?>.value(value: AuthService().authState(), initialData: null,),
        StreamProvider<List<Place>?>.value(value: LocationServices().fetchPlacesAsStream(), initialData: const [],),
        StreamProvider<List<Place>?>.value(value: LocationServices().fetchApprovedPlacesAsStream(), initialData: const [],),
        ChangeNotifierProvider(create: (BuildContext context) => LocationServices(), child: const AddPlace()),
        ChangeNotifierProvider(create: (BuildContext context) => CommentsServices(),),
        ChangeNotifierProxyProvider<CommentsServices, LikesComments>(create: (BuildContext context) => LikesComments(), update: (_, __, preview) {
          return preview!;
        }),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xfff1c40f),
            buttonTheme: const ButtonThemeData(
              buttonColor: AppColors.buttonColor,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.buttonColor,
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: AppColors.buttonColor,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: AppColors.buttonColor,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                primary: AppColors.buttonColor,
              ),
            )
          ),
          getPages: AppPages.pages,
          home: const MyHomePage(),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 2...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 1...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('go!');
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<User?>(builder: (context, value, child) {
      return const Wrapper();
    });
  }
}