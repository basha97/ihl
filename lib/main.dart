import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:ihl/shimmer_screen.dart';
import 'package:ihl/splash_screen.dart';
import 'package:ihl/utils.dart';

import 'constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

HealthFactory health = HealthFactory();

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode mode, ___) {
        return MaterialApp(
          scaffoldMessengerKey: messengerKey,
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const SplashScreen(),
        );
      },
    );
  }
}

class Health extends StatefulWidget {
  const Health({Key? key}) : super(key: key);

  @override
  State<Health> createState() => _HealthState();
}

class _HealthState extends State<Health> {
  Future<bool> checkAuthorization() async {
    final bool isRequested =
        await health.requestAuthorization(types, permissions: permissions);
    debugPrint(" ... $isRequested ... ");
    return isRequested;
  }

  Future fetchData() async {
    final isAuthorized = await checkAuthorization();
    try {
      if (isAuthorized) {
        int? steps;
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);
        steps = await health.getTotalStepsInInterval(midnight, now);
        return steps ?? 0;
      } else {
        Utils.showSnackBar("Please Authorize");
      }
    } catch (e) {
      throw "Access Denied";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_, __, ___) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Health App"),
              actions: [
                GestureDetector(
                  onTap: () {
                    themeNotifier.value = themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(themeNotifier.value == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode),
                  ),
                )
              ],
            ),
            body: FutureBuilder(
              future: fetchData(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ExampleUiLoadingAnimation();
                }
                if (snapshot.hasData) {
                  final value = snapshot.data as int;
                  return HealthCard(value: value);
                }
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Access Denied"),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => build(context),
                            ),
                          );
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}

class HealthCard extends StatelessWidget {
  final int value;

  const HealthCard({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = value / GOAL;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeNotifier.value == ThemeMode.light
                ? Colors.white
                : Colors.black12,
            blurRadius: 20.0,
          ),
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Steps : $value"),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: percentage,
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Text("0"),
                        Spacer(),
                        Text("Goals : $GOAL"),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SvgPicture.asset(FOOT_STEP),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
