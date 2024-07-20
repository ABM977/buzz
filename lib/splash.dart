import 'package:flutter/material.dart';

import 'authpage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    login(context);
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/a.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

      ],
    );
  }
}

login(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 4));
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthPage()));
}