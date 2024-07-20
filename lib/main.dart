import 'package:buzz/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
import 'Loginpage.dart';
import 'detailspage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey:"AIzaSyDtEgrLLKyWBBHo-g1J9vWEY3X7MpHlOeY" ,
          appId: "1:300179571203:android:53d1e8bfb9749941e3c436",
          messagingSenderId:"300179571203",
          projectId:"buzz-32413",
        storageBucket:"buzz-32413.appspot.com"
      ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home:
      // DetailsPage(email: null, name: null,),
      SplashPage(),
      // Homepage(bio: "",email: "",name: "",number: "",),

    );
  }
}
