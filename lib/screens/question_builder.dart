import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_query_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';

import '../constant/icon_repo.dart';
import '../constant/measurement_repo.dart';
import '../custom/widgets/bottomsheet_questions.dart';
import '../custom/widgets/loading_view.dart';
import '../custom/widgets/multiselect_screen.dart';
import '../custom/widgets/tabbar_screen.dart';
import '../fcm/firebase_repo.dart';
import '../key/key_showcase.dart';
import '../modal/color_modal.dart';

class QuestionBank extends StatefulWidget {
  const QuestionBank(
      {super.key, required this.categoryID, required this.title});

  final String categoryID;
  final String title;

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  final _fireStore = FirebaseFirestore.instance;
  late int indexBar = 0;
  late bool isTapFilter = false;
  final PageController pageController = PageController();
  late String token = '';

  // ShowCaseKeys showCaseKeys = ShowCaseKeys();
  final List<QueryDocumentSnapshot> mySolvedList = [];
  final List<QueryDocumentSnapshot> myUnSolvedList = [];

  //List<String> myTopics = [];
  List<String> mySelected = [];
  BuildContext? myContext;

  void showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    List myTopics = [];
    List<QueryDocumentSnapshot<Map<String, dynamic>>> topicList =
        await FireBaseDataBaseRepo().getDocsList('category');
    for (var element in topicList) {
      if (widget.title == element['title']) {
        myTopics = element['category'];
      }
    }

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // print('before multi select  : $mySelected');
        mySelected.clear();
        return MultiSelectUtil(
          myTopics: myTopics,
          mySelected: mySelected,
        );
      },
    );

    // Update UI
    // print('1111111 --------- ------selected multi check : $results');
    if (results != null) {
      setState(() {
        mySelected = results;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (ShowCaseKeys.isShowcase) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(myContext!).startShowCase(
          [
            ShowCaseKeys.five,
            ShowCaseKeys.six,
            ShowCaseKeys.seven,
            ShowCaseKeys.eight
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () => ShowCaseKeys.isShowcase = false,
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            //centerTitle: true,
            title: Text(
              widget.title,
              style: GoogleFonts.getFont('Roboto Slab',
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            flexibleSpace: Container(
              padding: MeasurementRepo.edgeTopThreeBottomTwo,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.center),
              ),
            ),
            actions: [
              Showcase(
                key: ShowCaseKeys.six,
                description: "Tap to search any queries.",
                child: MySearchScreen(
                  mySearchList: (indexBar == 0) ? mySolvedList : myUnSolvedList,
                  categoryID: widget.categoryID,
                  onTapBool: (indexBar == 0) ? true : false,
                ),
              ),
              Showcase(
                key: ShowCaseKeys.seven,
                description: "Tap to perform any filter .",
                child: IconButton(
                  icon: AppIconsRepo.filterIcon,
                  onPressed: showMultiSelect,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: MeasurementRepo.edgeAllEight,
                child: Wrap(
                  spacing: 5.0,
                  children: mySelected
                      .map(
                        (item) => Chip(
                          backgroundColor: MyColorsModal.kThemeColor,
                          label: Text(
                            item,
                            style: GoogleFonts.getFont('Roboto Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            setState(() {
                              mySelected.remove(item);
                            });
                          },
                          deleteIcon: AppIconsRepo.deleteForeverIcon,
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection('q&a').snapshots(),
                  builder: (context, snapshot) {
                    // print('@@@@@ passing category id from category screen : ${widget.categoryID}');
                    if (snapshot.hasError) {
                      // print("snapshot error : ${snapshot.error}");
                      return Center(child: Text("ERROR : ${snapshot.error}"));
                    }
                    if (!snapshot.hasData) {
                      return const LoadingDataView(text: "No results found");
                    }
                    myUnSolvedList.clear();
                    mySolvedList.clear();
                    final tabBarData = snapshot.data!;
                    for (int i = 0; i < tabBarData.size; i++) {
                      (tabBarData.docs[i]['answer'] == "")
                          ? myUnSolvedList.add(tabBarData.docs[i])
                          : mySolvedList.add(tabBarData.docs[i]);
                    }

                    // print('tab bar data : $tabBarData');
                    // print('tab at [0] data : $tab');
                    // print('tab bar myUnSolvedList : $myUnSolvedList');
                    // print('tab bar category : ${widget.categoryID}');
                    // print('tab bar mySolvedList : $mySolvedList');
                    // print('******** Select your topics question builder : $mySelected');
                    //final String selectDropItem = _selectedTab;

                    return Showcase(
                      key: ShowCaseKeys.eight,
                      description: "Open or Edit your required queries .",
                      child: PageView(
                        onPageChanged: (pageIndex) {
                          setState(
                            () {
                              indexBar = pageIndex;
                            },
                          );
                        },
                        controller: pageController,
                        children: [
                          NavBarListData(
                            myTabData: mySolvedList,
                            categoryID: widget.categoryID,
                            onTapBool: true,
                            selectedDropItem: mySelected,
                          ),
                          NavBarListData(
                            myTabData: myUnSolvedList,
                            categoryID: widget.categoryID,
                            onTapBool: false,
                            selectedDropItem: mySelected,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: Showcase(
            key: ShowCaseKeys.five,
            description: "Tap floating action button to add queries .",
            child: FloatingActionButton(
              backgroundColor: MyColorsModal.kThemeColor,
              onPressed: () async {
                mySelected.clear();
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => MyBottomSheet(
                    categoryID: widget.categoryID,
                  ),
                );
              },
              child: AppIconsRepo.addBoxIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: indexBar,
            selectedItemColor: const Color.fromRGBO(143, 148, 251, 1),
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/solved.png'),
                    size: 40,
                  ),
                  label: 'Solved'),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/unsolved.png'),
                    size: 40,
                  ),
                  label: 'Unsolved'),
            ],
            onTap: (index) {
              setState(() {
                indexBar = index;
              });
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut);
              // print('BottomNavigationBar index : $index');
            },
          ),
        );
      }),
    );
  }
}

// Widget addingQueries(){
//   return SingleChildScrollView(
//     child: Container(
//       padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(40.0),
//             topRight: Radius.circular(40.0)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(
//             left: 20, right: 20, bottom: 20, top: 10),
//         child: Column(
//           children: [
//             Container(
//               width: 100,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 50.0,
//               child: Text(
//                 'Do you have any more queries?',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.getFont('Roboto Slab',
//                     fontSize: 20.0),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     textAlign: TextAlign.center,
//                     controller: senderNameQuery,
//                     maxLines: null,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius:
//                           BorderRadius.circular(10.0)),
//                       border: OutlineInputBorder(
//                           borderRadius:
//                           BorderRadius.circular(10.0)),
//                       labelText: 'Your Name',
//                       labelStyle: TextStyle(
//                           color:
//                           Color.fromRGBO(143, 148, 251, 1)),
//                       hintText: 'Type here...',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     textAlign: TextAlign.center,
//                     controller: senderIdQuery,
//                     maxLines: null,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius:
//                           BorderRadius.circular(10.0)),
//                       border: OutlineInputBorder(
//                           borderRadius:
//                           BorderRadius.circular(10.0)),
//                       labelText: 'Your Code',
//                       labelStyle: TextStyle(
//                           color:
//                           Color.fromRGBO(143, 148, 251, 1)),
//                       hintText: 'Type here...',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Topics',
//                   textAlign: TextAlign.start,
//                   style: GoogleFonts.getFont('Roboto Slab',
//                       fontSize: 16.0),
//                 ),
//                 SizedBox(
//                   width: 30,
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.arrow_drop_down_circle_outlined,
//                       color: Color.fromRGBO(143, 148, 251, 1),
//                     ),
//                     onPressed: _showMultiSelect,
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: topicChipView(),
//                   ),
//                 ],
//               ),
//             ),
//             TextField(
//               textAlign: TextAlign.center,
//               controller: addQuery,
//               maxLines: null,
//               textInputAction: TextInputAction.done,
//               decoration: InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 labelText: 'Query Question',
//                 labelStyle: TextStyle(
//                     color: Color.fromRGBO(143, 148, 251, 1)),
//                 hintText: 'Write a question here...',
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             StreamBuilder<QuerySnapshot>(
//                 stream: _fireStore.collection('q&a').snapshots(),
//                 builder: (context, snapshot) {
//                   return InkWell(
//                     onTap: () async {
//                       if (addQuery.text.isNotEmpty &&
//                           mySelected.isNotEmpty &&
//                           senderNameQuery.text.isNotEmpty &&
//                           senderIdQuery.text.isNotEmpty) {
//                         print('button pressed');
//                         int? count = snapshot.data?.size;
//                         final data =
//                         _fireStore.collection('q&a').add({
//                           'name': senderNameQuery.text,
//                           'senderID': senderIdQuery.text,
//                           'answer': '',
//                           'categoryID': widget.categoryID,
//                           'questionID': count! + 1,
//                           'questions': addQuery.text,
//                           'description': '',
//                           'objects': mySelected
//                         });
//                         print(
//                             '------------@@@@@@@@@@@_selectedTab _fireStore : $mySelected');
//                         print('data _fireStore : $data');
//                         print(
//                             'data _fireStore text : ${addQuery.text}');
//                         Navigator.pop(context);
//                         await MyFcmNotification
//                             .postApiNotification(
//                             senderNameQuery.text,
//                             senderIdQuery.text,
//                             addQuery.text,
//                             context);
//                         addQuery.clear();
//                         print('button pressed close');
//                       } else {
//                         print(
//                             'Please enter question .Do not leave empty. ');
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: Text(
//                                   'Please fill out necessary information.',
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.getFont(
//                                       'Roboto Slab',
//                                       fontSize: 16.0),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text(
//                                         'OK',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Color.fromRGBO(
//                                               143, 148, 251, 1),
//                                         ),
//                                       ))
//                                 ],
//                               );
//                             });
//                       }
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 50,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           color:
//                           Color.fromRGBO(143, 148, 251, 0.8),
//                           borderRadius:
//                           BorderRadius.circular(30)),
//                       child: Text(
//                         'Submit',
//                         style: GoogleFonts.getFont('Roboto Slab',
//                             fontSize: 20.0,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   );
//                 }),
//           ],
//         ),
//       ),
//     ),
//   );
// }
