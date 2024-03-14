import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:code_query_app/modal/global_modal.dart' as globals;

import '../constant/sizedbox_constants.dart';
import 'category_screen.dart';
import 'login_screen.dart';

class SplashScreenRepo extends StatefulWidget {
  const SplashScreenRepo({Key? key}) : super(key: key);
  static String id = '/';

  @override
  State<SplashScreenRepo> createState() => _SplashScreenRepoState();
}

class _SplashScreenRepoState extends State<SplashScreenRepo> {
  bool isLoading = false;

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    // print("splash screen navigated .");
    String route = '/';
    try {
      //print('---------- globals.isLogin : ${globals.isLogin}');
      globals.isLogin ? route = CategoryScreen.id : route = LoginPage.id;
      Navigator.of(context).pushReplacementNamed(route);
    } catch (e) {
      // print('null globals.isLogin');
      navigationPage();
    }
  }

  void getTimerForLoading() {
    Timer(
      const Duration(seconds: 1),
      () => setState(() => isLoading = true),
    );
  }

  @override
  void initState() {
    super.initState();
    getTimerForLoading();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: Image.asset("assets/background/app_logo.png"),
                ),
                KSizedBox.sizeHeightTen,
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Query Next".toUpperCase(),
                      speed: const Duration(milliseconds: 200),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // Text(
                //   "Query Next".toUpperCase(),
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                isLoading
                    ? Lottie.network(
                        'https://assets8.lottiefiles.com/packages/lf20_dm93vJ9VUn.json',
                        // repeat : false,
                        fit: BoxFit.fitWidth,
                      )
                    : const Center(),
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            child: Text("version: 1.0.0"),
          ),
        ],
      ),
    );
  }
}
