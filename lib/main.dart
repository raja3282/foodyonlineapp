import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foody_online_app/constant/const.dart';
import 'package:foody_online_app/providers/manageMaps.dart';
import 'package:foody_online_app/providers/app.dart';
import 'package:foody_online_app/providers/auth.dart';
import 'package:foody_online_app/providers/categoryprovider.dart';
import 'package:foody_online_app/providers/my_provider.dart';
import 'package:foody_online_app/screens/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FoodyOnlineApp());
}

class FoodyOnlineApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => (Authentication())),
        ChangeNotifierProvider(create: (_) => (GenerateMaps())),
        ChangeNotifierProvider(create: (_) => (MyProvider())),
        ChangeNotifierProvider(create: (_) => (AppProvider())),
        ChangeNotifierProvider(create: (_) => (CategoryProvider.initialize()))
      ],
      child: MaterialApp(
        title: 'Foody Online Delivery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}
