import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:query_app/constants/icon_repo.dart';
import 'package:query_app/constants/measurement_repo.dart';
import 'package:query_app/constants/sizedbox_constants.dart';
import 'package:query_app/databaseManager/my_shared_preferences.dart';
import 'package:query_app/screens/login_screen.dart';
import 'package:query_app/screens/query_answer.dart';
import 'package:query_app/screens/widget/loading_view.dart';

import '../modal/color_modal.dart';
import 'answer_screen.dart';

class NavBarListData extends StatefulWidget {
  const NavBarListData({
    super.key,
    required this.myTabData,
    required this.categoryID,
    required this.onTapBool,
    required this.selectedDropItem,
  });

  final List<QueryDocumentSnapshot> myTabData;
  final String categoryID;
  final bool onTapBool;
  final List<String> selectedDropItem;

  @override
  State<NavBarListData> createState() => _NavBarListDataState();
}

class _NavBarListDataState extends State<NavBarListData> {
  @override
  Widget build(BuildContext context) {
    if (widget.myTabData.isEmpty) {
      return const LoadingDataView(
        text: 'No results found',
      );
    }

    return Padding(
      padding: MeasurementRepo.edgeOnlyFive,
      child: FutureBuilder(
        future: MySharedPreferences.getUserDefault('userLogin'),
        builder: (context, snapshot) {
          //print('future snapshot data pref.setBool tab bar : ${snapshot.data}');
          return ListView.builder(
            itemCount: widget.myTabData.length,
            itemBuilder: (context, index) {
              String category = widget.myTabData[index]['categoryID'];
              String name = widget.myTabData[index]['name'];
              List objectData = widget.myTabData[index]['objects'];
              // String nameID = widget.myTabData[index]['senderID'];
              //print('Nav bar widget data check : $category');
              // print('Nav bar widget data check : $objectData');
              //print('widget.selectedDropItem.contains(objectData) : ${widget.selectedDropItem.contains(objectData[0])}');

              if (widget.categoryID == category) {
                if (widget.selectedDropItem.isNotEmpty) {
                  for (int i = 0; i < widget.selectedDropItem.length; i++) {
                    if (objectData.contains(widget.selectedDropItem[i])) {
                      //print('widget.selectedDropItem[0] == objectData[0] : ${widget.selectedDropItem[0] == objectData[0]}');
                      return GestureDetector(
                        onTap: () {
                          if (widget.onTapBool) {
                            // print('This is executed when the question builder request some answers ...');
                            // final questionId = widget.myTabData[index]['questionID']; //snapshot.data!.docs[index]['questionID'];
                            // print('@@@ data answerId : $category');
                            // print('%%% data questionId : $questionId');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnswerWindowScreen(
                                  answerData: widget.myTabData[index],
                                ),
                              ),
                            );
                          } else {
                            // print('This container tap feature has been disabled .');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            gradient:
                                MyColorsModal.alphaGradientColors()[index % 6]
                                    .scale(0.5),
                          ),
                          child: ListTile(
                            visualDensity: const VisualDensity(horizontal: -4),
                            contentPadding: MeasurementRepo.edgeAllFive,
                            horizontalTitleGap: 0,
                            title: Card(
                              color: Colors.white,
                              elevation: 15,
                              child: Padding(
                                padding: MeasurementRepo.edgeAllFive,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.myTabData[index]['questions']
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.getFont('Roboto Slab',
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: MeasurementRepo.edgeRightFive,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: MyColorsModal
                                                        .alphaGradientColors()[
                                                    index % 6]
                                                .colors[1]
                                                .withOpacity(0.8),
                                            minRadius: 7,
                                            child: Text(
                                              name.characters.first
                                                  .toUpperCase(),
                                              style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ),
                                          KSizedBox.sizeWidthFive,
                                          Text(
                                            name,
                                            style: GoogleFonts.getFont(
                                                'Roboto Slab',
                                                fontSize: 11.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            subtitle: (widget.myTabData[index]['answer'] ==
                                        '' &&
                                    snapshot.data == true)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          final data = widget.myTabData[index];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QueryAnswer(
                                                queryQuestionData: data,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            AppIconsRepo.pencilBlackIcon,
                                            Text(
                                              'Add Answer',
                                              style: GoogleFonts.getFont(
                                                'Roboto Slab',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Do you really want to delete ?',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.getFont(
                                                      'Roboto Slab',
                                                      fontSize: 16.0),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: MyColorsModal
                                                            .kThemeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deleteContainer(widget
                                                          .myTabData[index].id);
                                                      setState(() {
                                                        widget.myTabData.remove(
                                                            widget.myTabData[
                                                                index]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: MyColorsModal
                                                            .kThemeColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            AppIconsRepo.deleteSweepBlackIcon,
                                            Text(
                                              ' Delete',
                                              style: GoogleFonts.getFont(
                                                'Roboto Slab',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      );
                    }
                  }
                } else {
                  return GestureDetector(
                    onLongPress: () async {
                      bool isLongPress =
                          (await MySharedPreferences.getUserDefault(
                              'userLogin'))!;
                      if (isLongPress && widget.onTapBool) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Stored information is important.Do you really want to delete it ? ',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.getFont('Roboto Slab',
                                    fontSize: 16.0),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    deleteContainer(widget.myTabData[index].id);
                                    setState(
                                      () {
                                        widget.myTabData
                                            .remove(widget.myTabData[index]);
                                      },
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: MyColorsModal.kThemeColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: MyColorsModal.kThemeColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                      // print('onLongPress is disabled on users.');
                    },
                    onTap: () {
                      if (widget.onTapBool) {
                        // print('This is executed when the question builder request some answers ...');
                        // final questionId = widget.myTabData[index]['questionID']; //snapshot.data!.docs[index]['questionID'];
                        // print('@@@ data answerId : $category');
                        // print('%%% data questionId : $questionId');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnswerWindowScreen(
                              answerData: widget.myTabData[index],
                            ),
                          ),
                        );
                      } else {
                        // print('This container tap feature has been disabled .');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                (snapshot.data == true)
                                    ? 'This container tap feature has been disabled.'
                                    : 'This container tap feature has been disabled. Please login to add answer.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont('Roboto Slab',
                                    fontSize: 16.0),
                              ),
                              actions: [
                                (snapshot.data == true)
                                    ? const Center()
                                    : TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, LoginPage.id);
                                        },
                                        child: const Text(
                                          'Want to Login?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: MyColorsModal.kThemeColor,
                                          ),
                                        ),
                                      ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    (snapshot.data == true) ? 'OK' : 'Cancel',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: MyColorsModal.kThemeColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        gradient: MyColorsModal.alphaGradientColors()[index % 6]
                            .scale(0.5),
                      ),
                      child: ListTile(
                        contentPadding: MeasurementRepo.edgeOnlyFive,
                        title: Card(
                          color: Colors.white,
                          elevation: 15,
                          child: Padding(
                            padding: MeasurementRepo.edgeAllEight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.myTabData[index]['questions']
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                KSizedBox.sizeHeightFive,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: MyColorsModal
                                              .alphaGradientColors()[index % 6]
                                          .colors[1]
                                          .withOpacity(0.8),
                                      minRadius: 7,
                                      child: Text(
                                        name.characters.first.toUpperCase(),
                                        style: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ),
                                    KSizedBox.sizeWidthFive,
                                    Text(
                                      name,
                                      style: GoogleFonts.getFont('Roboto Slab',
                                          fontSize: 11.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        subtitle: (widget.myTabData[index]['answer'] == '' &&
                                snapshot.data == true)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      final data = widget.myTabData[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QueryAnswer(
                                            queryQuestionData: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        AppIconsRepo.pencilBlackIcon,
                                        Text(
                                          'Add Answer',
                                          style: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Do you really want to delete ?',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  fontSize: 16.0),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColorsModal
                                                        .kThemeColor,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteContainer(widget
                                                      .myTabData[index].id);
                                                  setState(
                                                    () {
                                                      widget.myTabData.remove(
                                                          widget.myTabData[
                                                              index]);
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColorsModal
                                                        .kThemeColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        AppIconsRepo.deleteSweepBlackIcon,
                                        Text(
                                          ' Delete',
                                          style: GoogleFonts.getFont(
                                            'Roboto Slab',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  );
                }
              }
              return const Center();
            },
          );
        },
      ),
    );
  }

  void deleteContainer(id) {
    FirebaseFirestore.instance.collection("q&a").doc(id).delete();
  }
}

// trailing: (widget.myTabData[index]['answer'] ==
//             '' &&
//         snapshot.data == true)
//     ? PopupMenuButton<int>(
//         surfaceTintColor: Colors.black,
//         tooltip: 'More',
//         padding: EdgeInsets.zero,
//         itemBuilder: (BuildContext context) {
//           return [
//             PopupMenuItem(
//               value: 0,
//               child: Text(
//                 'Add Answer',
//                 style: GoogleFonts.getFont(
//                   'Roboto Slab',
//                 ),
//               ),
//             ),
//             PopupMenuItem(
//               value: 1,
//               child: Text(
//                 'Delete',
//                 style: GoogleFonts.getFont(
//                   'Roboto Slab',
//                 ),
//               ),
//             ),
//           ];
//         },
//         icon: Icon(
//           CupertinoIcons.ellipsis_vertical,
//           color: Colors.black,
//         ),
//         onSelected: (value) {
//           if (value == 0) {
//             final data = widget.myTabData[index];
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         QueryAnswer(
//                           queryQuestionData: data,
//                         )));
//           } else if (value == 1) {
//             showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text(
//                       'Do you really want to delete ?',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.getFont(
//                           'Roboto Slab',
//                           fontSize: 16.0),
//                     ),
//                     actions: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(
//                                 context);
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color:
//                               MyColorsModal.kThemeColor,
//                             ),
//                           ),),
//                       TextButton(
//                           onPressed: () {
//                             deleteContainer(widget
//                                 .myTabData[index]
//                                 .id);
//                             setState(() {
//                               widget.myTabData
//                                   .remove(widget
//                                           .myTabData[
//                                       index]);
//                             });
//                             Navigator.pop(context);
//                           },
//                           child: Text(
//                             'OK',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color:
//                               MyColorsModal.kThemeColor,
//                             ),
//                           )),
//                     ],
//                   );
//                 });
//           }
//         },
//       )
//     : null,
