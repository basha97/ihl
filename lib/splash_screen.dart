import 'package:flutter/material.dart';
import 'package:ihl/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const Health();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: FlutterLogo(size: 50)),
    );
  }
}
