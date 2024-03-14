import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../fcm/fcm_notification.dart';
import '../../fcm/firebase_repo.dart';
import '../../modal/color_modal.dart';
import 'multiselect_screen.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key, required this.categoryID});

  final String categoryID;

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final _fireStore = FirebaseFirestore.instance;
  List<String> mySelected = [];
  TextEditingController addQuery = TextEditingController();
  TextEditingController senderNameQuery = TextEditingController();
  TextEditingController senderIdQuery = TextEditingController();
  double opacity = 0.3;
  final formKey = GlobalKey<FormState>();

  Widget topicChipView() {
    return Wrap(
      spacing: 5.0,
      children: mySelected
          .map((item) => Chip(
                backgroundColor: const Color.fromRGBO(143, 148, 251, 0.6),
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
                deleteIcon: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                ),
              ))
          .toList(),
    );
  }

  void showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    List myTopics = [];
    List<QueryDocumentSnapshot<Map<String, dynamic>>> topicList =
        await FireBaseDataBaseRepo().getDocsList('category');
    for (var element in topicList) {
      if (widget.categoryID == element.id) {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: Form(
            key: formKey,
            onChanged: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  opacity = 1;
                });
              } else {
                setState(() {
                  opacity = 0.3;
                });
              }
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50.0,
                  child: Text(
                    'Do you have any more queries?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Roboto Slab',
                        fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: senderNameQuery,
                        maxLines: null,
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Your Name',
                          labelStyle: const TextStyle(
                            color: MyColorsModal.kThemeColor,
                          ),
                          hintText: 'Type here...',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: senderIdQuery,
                        maxLines: null,
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Your Code',
                          labelStyle: const TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          hintText: 'Type here...',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Topics',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.getFont('Roboto Slab', fontSize: 16.0),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        onPressed: showMultiSelect,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: topicChipView(),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: addQuery,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Query Question',
                    labelStyle: const TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1)),
                    hintText: 'Write a question here...',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('q&a').snapshots(),
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (mySelected.isNotEmpty) {
                              // print('button pressed');
                              int? count = snapshot.data?.size;
                              final data = _fireStore.collection('q&a').add({
                                'name': senderNameQuery.text,
                                'senderID': senderIdQuery.text,
                                'answer': '',
                                'categoryID': widget.categoryID,
                                'questionID': count! + 1,
                                'questions': addQuery.text,
                                'description': '',
                                'objects': mySelected
                              });
                              Navigator.pop(context);
                              String fcmDataId = '';
                              await data.then(
                                (value) {
                                  fcmDataId = value.id;
                                },
                              ).then(
                                (value) async {
                                  await MyFcmNotification.postApiNotification(
                                      senderNameQuery.text,
                                      senderIdQuery.text,
                                      addQuery.text,
                                      fcmDataId,
                                      context);
                                },
                              );

                              // print('data _fireStore : $data');
                              // print('------------@@@@@@@@@@@_selectedTab _fireStore : $mySelected');
                              // print('data _fireStore : $data');
                              // print('data _fireStore text : ${addQuery.text}');
                              addQuery.clear();
                              // print('button pressed close');
                            } else {
                              // print('Please enter all fields.Do not leave them empty.');
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Please fill all necessary information.',
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
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 1),
                                              ),
                                            ))
                                      ],
                                    );
                                  });
                            }
                          } else {
                            return;
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(143, 148, 251, opacity),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Submit',
                            style: GoogleFonts.getFont('Roboto Slab',
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
