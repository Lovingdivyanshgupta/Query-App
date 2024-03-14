import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:query_app/constants/icon_repo.dart';
import 'package:query_app/databaseManager/my_shared_preferences.dart';
import 'package:query_app/screens/answer_screen.dart';
import 'package:query_app/screens/query_answer.dart';
import 'package:search_page/search_page.dart';

import '../modal/color_modal.dart';
import 'login_screen.dart';

class MySearchScreen extends StatelessWidget {
  const MySearchScreen(
      {super.key,
      required this.mySearchList,
      required this.categoryID,
      required this.onTapBool});

  final List<QueryDocumentSnapshot> mySearchList;
  final String categoryID;
  final bool onTapBool;

  List<QueryDocumentSnapshot<Object?>> getSearchingResult() {
    List<QueryDocumentSnapshot> myList = [];
    for (int i = 0; i < mySearchList.length; i++) {
      if (mySearchList[i]['categoryID'] == categoryID) {
        myList.add(mySearchList[i]);
      }
    }
    //print('my search list from search screen : $myList');
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: SearchPage(
            barTheme: ThemeData(
              textSelectionTheme:
                  const TextSelectionThemeData(cursorColor: Colors.white),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColorsModal.kThemeColor),
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: MyColorsModal.kThemeColor,
              ),
            ),
            onQueryUpdate: (val) {
              //print('qwerty : $val');
            },
            items: getSearchingResult(),
            searchLabel: 'Search query',
            suggestion: const Center(
              child: Text('Filter questions by typing characters.  '),
            ),
            failure: const Center(
              child: Text('No question found.'),
            ),
            filter: (person) => [
              person.id,
              person['questions'],
            ],
            //sort: (a, b) => a.compareTo(b),
            builder: (person) => InkWell(
              onTap: () async {
                if (onTapBool) {
                  QueryDocumentSnapshot<Object?> data = person;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnswerWindowScreen(answerData: data)));
                } else {
                  bool isLogin =
                      (await MySharedPreferences.getUserDefault('userLogin'))!;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          (isLogin)
                              ? 'This container tap feature has been disabled.'
                              : 'This container tap feature has been disabled. Please login to add answer.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto Slab',
                            fontSize: 16.0,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              (isLogin)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QueryAnswer(
                                          queryQuestionData: person,
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                            },
                            child: Text(
                              (isLogin) ? 'Edit answer' : 'Want to Login?',
                              style: const TextStyle(
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
              },
              child: ListTile(
                title: Text(person['questions']),
                leading: AppIconsRepo.searchIcon,
                //subtitle: Text(person.reference.path),
                // trailing: Text('${person.id}'),
              ),
            ),
          ),
        );
      },
      icon: AppIconsRepo.searchIcon,
    );
  }
}

// class Person implements Comparable<Person> {
//   final String name, surname;
//   final num age;
//
//   const Person(this.name, this.surname, this.age);
//
//   @override
//   int compareTo(Person other) => name.compareTo(other.name);
// }
