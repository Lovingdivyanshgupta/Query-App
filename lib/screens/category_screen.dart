import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_query_app/screens/question_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../constant/measurement_repo.dart';
import '../custom/paint/custom_paint.dart';
import '../custom/widgets/custom_drawer.dart';
import '../custom/widgets/loading_view.dart';
import '../fcm/firebase_repo.dart';
import '../fcm/notification_listen.dart';
import '../key/key_showcase.dart';
import '../main.dart';
import '../modal/color_modal.dart';
import '../preferences/my_shared_preferences.dart';
import '../route/animated_route.dart';
import 'login_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static String id = '/category';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController query = TextEditingController();
  final List<IconData> icons = [
    Icons.developer_mode,
    Icons.mobile_friendly_sharp,
    Icons.code,
    Icons.developer_board,
  ];

  List categoryList = [];
  final colorModal = MyColorsModal();
  String tokenSender = '';

  FireBaseDataBaseRepo fireBaseDB = FireBaseDataBaseRepo();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> myCategoryData = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> myQAData = [];
  late SharedPreferences sharedPreferences;
  bool isLogin = false;
  bool isDrawer = false;
  String? profileName;

  // ShowCaseKeys showCaseKeys = ShowCaseKeys();

  @override
  void initState() {
    fetchDatabaseList();
    super.initState();
    getProfileName();
    MyNotificationListen().getNotificationListenData(
        navigatorKey.currentState?.context ?? context);
  }

  fetchDatabaseList() async {
    isLogin = (await MySharedPreferences.getUserDefault('userLogin'))!;
    myCategoryData = await fireBaseDB.getDocsList('category');
    //print('mySnap collection FirebaseFireStore : $myCategoryData');
    //print('mySnap collection FirebaseFireStore : ${myCategoryData[0].data()}');
  }

  Future<void> getProfileName() async {
    profileName =
        await MySharedPreferences.getStringUserDefault('profileName') ??
            "Guest";
  }

  void onPressedDrawerCloseIcon() => setState(() => isDrawer = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      body: ShowCaseWidget(
        onStart: (index, key) {
          // print('onStart: $index, $key , ${key.currentContext}');
        },
        autoPlayDelay: const Duration(seconds: 3),
        onComplete: (index, key) {
          // print('onComplete: $index, $key');
          if (index == 5) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
            );
          }
        },
        blurValue: 1,
        builder: Builder(
          // key: ShowCaseKeys.contextKey,
          builder: (context) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: MeasurementRepo.edgeTopFiftyOtherTwenty,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Showcase(
                            key: ShowCaseKeys.two,
                            description: 'Click to open drawer',
                            disableDefaultTargetGestures: true,
                            onBarrierClick: () {
                              debugPrint("on barrier click .");
                            },
                            child: IconButton(
                              icon:
                                  const Icon(CupertinoIcons.line_horizontal_3),
                              onPressed: () {
                                isDrawer = !isDrawer;
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Categories',
                                  textStyle: GoogleFonts.getFont('Roboto Slab',
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                  colors: [
                                    Colors.black,
                                    Colors.indigoAccent,
                                    Colors.pinkAccent,
                                    Colors.orangeAccent
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: fireBaseDB.getDocsList('category'),
                      builder: (context, snapshot) {
                        myCategoryData = snapshot.data ?? [];
                        if (snapshot.hasError) {
                          return LoadingDataView(
                              text: snapshot.error.toString());
                        }

                        if (myCategoryData.isEmpty) {
                          return const LoadingDataView(
                            text: 'Please Wait',
                          );
                        }
                        return Expanded(
                          child: GridView.count(
                            childAspectRatio: 1,
                            crossAxisCount: 2,
                            children: List.generate(
                              myCategoryData.length,
                              (index) {
                                final titleId = myCategoryData[index].id;

                                Widget setCategoryWidget() {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        AnimatedRoute(
                                          route: QuestionBank(
                                            categoryID: titleId,
                                            title: myCategoryData[index]
                                                ['title'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: AnimatedContainer(
                                      margin: MeasurementRepo.edgeAllTen,
                                      padding: MeasurementRepo.edgeAllTen,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.08, color: Colors.black45),
                                        borderRadius: BorderRadius.circular(20),

                                        gradient: MyColorsModal
                                            .cardGradientColors()[index % 6],
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.grey,
                                        //       spreadRadius: 0,
                                        //       blurRadius: 6,
                                        //       offset: Offset(0,2)
                                        //   ),
                                        // ],
                                      ),
                                      duration: const Duration(seconds: 1),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            myCategoryData[index]['title'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.getFont(
                                                'Roboto Slab',
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Image(
                                              width: 100,height: 100,
                                              image: NetworkImage(
                                                myCategoryData[index]['image'],
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return (ShowCaseKeys.isShowcase && index == 0)
                                    ? Showcase(
                                        key: ShowCaseKeys.four,
                                        description:
                                            'Tap to navigate to queries related to that category.',
                                        onTargetClick: () {
                                          // print("target click object");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QuestionBank(
                                                categoryID: titleId,
                                                title: myCategoryData[0]
                                                    ["title"],
                                              ),
                                            ),
                                          ).then((_) {
                                            ShowCaseWidget.of(context).next();
                                          });

                                          // print("on target complete : $titleId , ${myCategoryData[0]["title"]}");
                                        },
                                        disposeOnTap: true,
                                        child: setCategoryWidget(),
                                      )
                                    : setCategoryWidget();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Stack(
                      children: [
                        CustomPaint(
                            painter: CustomPainterClass(),
                            size: Size(MediaQuery.of(context).size.width, 80)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: ListView.separated(
                            padding: MeasurementRepo.edgeAllTen,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: icons.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (myCategoryData.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuestionBank(
                                          title: myCategoryData[index]["title"],
                                          categoryID: myCategoryData[index].id,
                                        ),
                                      ),
                                    );
                                  }
                                  // else {
                                  //   print('Navigation disable due to empty data from firebase.');
                                  // }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        icons[index],
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (index == 1)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                      ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ),
                        ),
                        Center(
                          heightFactor: 0.8,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                AnimatedRoute(
                                  route: const LoginPage(),
                                ),
                              );
                            },
                            backgroundColor: MyColorsModal.kThemeColor,
                            elevation: 0.1,
                            child: const Icon(
                              Icons.home_rounded,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                (isDrawer)
                    ? CustomDrawerView(
                        onPressedCloseIcon: onPressedDrawerCloseIcon,
                        profileName: profileName!,
                      )
                    : const Center(),
              ],
            );
          },
        ),
      ),
    );
  }
}
