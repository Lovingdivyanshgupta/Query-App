import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:query_app/constants/icon_repo.dart';
import 'package:query_app/constants/measurement_repo.dart';
import 'package:query_app/constants/sizedbox_constants.dart';
import 'package:query_app/databaseManager/my_shared_preferences.dart';
import 'package:query_app/screens/category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/color_modal.dart';
import 'fade_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;

  String? email;
  String? password;
  GlobalKey globalKey = GlobalKey();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                      1.3,
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/light-2.png'))),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                      1.5,
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png'))),
                      ),
                    ),
                  ),
                  Positioned(
                    child: FadeAnimation(
                        1.6,
                        Container(
                          margin: MeasurementRepo.edgeOnlyTopFifty,
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.getFont('Roboto Slab',
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: MeasurementRepo.edgeAllThirty,
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1.8,
                    Form(
                      key: globalKey,
                      child: Container(
                        padding: MeasurementRepo.edgeAllFive,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Theme(
                          data: ThemeData.light().copyWith(
                            inputDecorationTheme: InputDecorationTheme(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 60,
                                padding: MeasurementRepo.edgeOnlyEight,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade100))),
                                child: TextFormField(
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  // validator: (value) {
                                  //   if (value != '') {
                                  //     return 'Empty';
                                  //   }
                                  // },
                                  cursorColor:
                                      const Color.fromRGBO(143, 148, 251, 1),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email or Phone number",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                height: 60,
                                padding: MeasurementRepo.edgeOnlyEight,
                                child: TextFormField(
                                  obscureText: isPasswordVisible,
                                  onEditingComplete: () async {
                                    FocusScope.of(context).unfocus();
                                    // print('Login email : $email');
                                    // print('Login password : $password');
                                    try {
                                      await auth.signInWithEmailAndPassword(
                                          email: email.toString(),
                                          password: password.toString());

                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setBool('userLogin', true);
                                      // bool? setBool = pref.getBool('userLogin');
                                      // print('pref.isLogin : $setBool');
                                      // print('Login email : $email');
                                      // print('Login password : $password');
                                      String profileName = email.toString().split("@")[0];
                                      profileName = profileName[0].toUpperCase() + profileName.substring(1);
                                      if(profileName.contains(".")){
                                        profileName = profileName.split(".")[0];
                                      }
                                      MySharedPreferences.setStringUserDefault("profileName", profileName);
                                      // var str = await MySharedPreferences.getStringUserDefault("profileName");
                                      Navigator.pushNamed(
                                          context, CategoryScreen.id);
                                    } on FirebaseAuthException catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.message.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  cursorColor: MyColorsModal.kThemeColor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          },
                                        );
                                      },
                                      icon: (isPasswordVisible)
                                          ? AppIconsRepo.eyeFillIcon
                                          : AppIconsRepo.eyeSlashIcon,
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  KSizedBox.sizeHeightThirty,
                  FadeAnimation(
                    2,
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        // print('Login email : $email');
                        // print('Login password : $password');
                        try {
                          await auth.signInWithEmailAndPassword(
                              email: email.toString(),
                              password: password.toString());

                          bool? isLogin =
                              await MySharedPreferences.setUserDefault(
                                  'userLogin', true);
                          // String profileName =
                          //     auth.currentUser!.displayName ?? "Unknown";
                          // print("name : $profileName");
                          // MySharedPreferences.setStringUserDefault(
                          //     "profileName", profileName);
                          //


                          if (kDebugMode) {
                            print('pref.isLogin : $isLogin');
                          }
                          String profileName = email.toString().split("@")[0];
                          profileName = profileName[0].toUpperCase() + profileName.substring(1);
                          if(profileName.contains(".")){
                            profileName = profileName.split(".")[0];
                          }
                          MySharedPreferences.setStringUserDefault("profileName", profileName);
                          // var str = await MySharedPreferences.getStringUserDefault("profileName");
                          // print("str name login : $str");
                          Navigator.pushNamed(context, CategoryScreen.id);
                          // print('Login email : $email');
                          // print('Login password : $password');
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message.toString())));
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              MyColorsModal.kThemeColor,
                              MyColorsModal.kThemeColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: GoogleFonts.getFont(
                              'Roboto Slab',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  KSizedBox.sizeHeightSeventy,
                  FadeAnimation(
                    1.5,
                    RawMaterialButton(
                      fillColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        Navigator.pushNamed(context, CategoryScreen.id);
                        bool? isLogin =
                            await MySharedPreferences.setUserDefault(
                                'userLogin', false);
                        MySharedPreferences.setStringUserDefault(
                            "profileName", "Guest");

                        // var str = await MySharedPreferences.getStringUserDefault("profileName");
                        // print("str name : $str");
                        if (kDebugMode) {
                          print('pref.isLogin : $isLogin');
                        }
                      },
                      child: Text(
                        "Skip",
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                          fontSize: 18.0,
                          color: MyColorsModal.kThemeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
