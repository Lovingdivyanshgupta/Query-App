import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../constant/icon_repo.dart';
import '../constant/measurement_repo.dart';
import '../constant/sizedbox_constants.dart';
import '../fcm/firebase_repo.dart';
import '../modal/color_modal.dart';

class QueryAnswer extends StatefulWidget {
  final QueryDocumentSnapshot queryQuestionData;

  const QueryAnswer({super.key, required this.queryQuestionData});

  @override
  State<QueryAnswer> createState() => _QueryAnswerState();
}

class _QueryAnswerState extends State<QueryAnswer> {
  TextEditingController descText = TextEditingController();
  TextEditingController stepText = TextEditingController();
  String userInput = '';
  String stepChangedText = '';
  List<String> answerList = [];
  List<TextEditingController> answerFields = [TextEditingController()];
  double height = 90;
  bool isUpload = false;
  List<int> uploadIndex = [];
  var storage = FirebaseStorage.instance;
  var picker = ImagePicker();
  dynamic dropDownValue;
  dynamic dropDownValuePop = 0;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> popMenuQaData = [];

  bool popUpEnable = false;
  Set popUpLinkQuestion = {};
  Set popUpLinkIDs = {};

  // @override
  // void initState() {
  //   super.initState();
  // }
  void getPopMenuData() async {
    var docs = FireBaseDataBaseRepo();
    popMenuQaData = await docs.getDocsList('q&a');
  }

  @override
  Widget build(BuildContext context) {
    getPopMenuData();
    return Scaffold(
      backgroundColor: const Color(0xF0FFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"), fit: BoxFit.cover, alignment: Alignment.center),
                color: MyColorsModal.kThemeColor,
              ),
              padding: MeasurementRepo.edgeTopTwentyFive,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  Text(
                    'Edit Query ',
                    style: GoogleFonts.getFont('Roboto Slab',
                        fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              padding: MeasurementRepo.edgeAllTen,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: MeasurementRepo.edgeSymmetricTenFive,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: MeasurementRepo.edgeOnlyTopTen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: MeasurementRepo.edgeAllTen,
                              child: Text(
                                'Question : ',
                                style: GoogleFonts.getFont('Roboto Slab', fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              margin: MeasurementRepo.edgeAllEight,
                              color: MyColorsModal.kThemeColor,
                              child: Padding(
                                padding: MeasurementRepo.edgeAllEight,
                                child: Text(
                                  widget.queryQuestionData['questions'],
                                  style: GoogleFonts.getFont(
                                    'Roboto Slab',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: MeasurementRepo.edgeAllTen,
                              child: Text(
                                'Answer : ',
                                style: GoogleFonts.getFont('Roboto Slab',
                                    fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: List.generate(
                                answerFields.length,
                                (index) => Padding(
                                  padding: MeasurementRepo.edgeOnlyBottomTwenty,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60.0,
                                        alignment: Alignment.center,
                                        padding: MeasurementRepo.edgeAllEight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 1.0, color: Colors.grey),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: GoogleFonts.getFont('Roboto Slab',
                                              color: Colors.black, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      KSizedBox.sizeWidthFive,
                                      (answerList.isNotEmpty && isUpload && uploadIndex.contains(index))
                                          ? SizedBox(
                                              width: 120,
                                              height: 120,
                                              child: (answerList[index].contains('.json'))
                                                  ? Lottie.network(answerList[index], fit: BoxFit.fill)
                                                  : Image.network(
                                                      answerList[index],
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                            )
                                          : Expanded(
                                              child: TextFormField(
                                                controller: answerFields[index],
                                                maxLines: null,
                                                textInputAction: TextInputAction.done,
                                                onChanged: (value) {
                                                  //stepChangedText = value;
                                                  //print('value of on changed : $value');
                                                  //print('value of on changed : $stepChangedText');
                                                },
                                                onFieldSubmitted: (newText) {
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  if (answerFields[index].text.isNotEmpty) {
                                                    // print('## @@ answerFields list widget : ${answerFields[index].text} ');
                                                    setState(() {
                                                      answerFields.add(TextEditingController());
                                                    });
                                                    // print('## @@ answerFields list widget : ${answerFields[index].text} ');
                                                    answerList.add(newText);
                                                    // print('answerList @@@ step text : $answerList');
                                                  } else {
                                                    // print('empty answerList @@@ step text : $answerList');
                                                  }
                                                },
                                                style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  labelStyle: GoogleFonts.getFont(
                                                    'Roboto Slab',
                                                    color: MyColorsModal.kThemeColor,
                                                  ),
                                                  labelText: 'Step ${index + 1}',
                                                  hintText: 'Enter Step ${index + 1} here...',
                                                ),
                                              ),
                                            ),
                                      (answerFields.length > 1 &&
                                              (answerFields[index] != answerFields[answerFields.length - 1]))
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  // print('@@ answerFields list widget : ${answerFields.length} ');
                                                  answerFields.removeAt(index);
                                                  answerList.removeAt(index);
                                                  //isUpload = false;
                                                  // print('before upload index at remove : $uploadIndex ');
                                                  uploadIndex.remove(index);
                                                  // List<int> uploadIndexTemp = [];
                                                  // uploadIndexTemp = uploadIndex;
                                                  for (int i = 0; i < uploadIndex.length; i++) {
                                                    // print('!! upload index : $uploadIndex ');
                                                    if (uploadIndex[i] >= index) {
                                                      uploadIndex[i] -= 1;
                                                    }
                                                  }
                                                  // print('upload index at remove : $uploadIndex ');
                                                  // print('@@ answerFields.removeAt(index) && uploadIndex: ${answerFields.length} && $uploadIndex');
                                                  // print('@@ answerList.removeAt(index); : $answerList ');
                                                });
                                              },
                                              icon: AppIconsRepo.removeCircleIcon,
                                            )
                                          : const Center(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            (popUpEnable && popUpLinkQuestion.isNotEmpty)
                                ? Padding(
                                    padding: MeasurementRepo.edgeAllTen,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Links : ',
                                          style: GoogleFonts.getFont('Roboto Slab',
                                              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                        Wrap(
                                          spacing: 5,
                                          children: List.generate(
                                            popUpLinkQuestion.toList().length,
                                            (index) => Chip(
                                              backgroundColor: MyColorsModal.kThemeColor,
                                              elevation: 3,
                                              label: Text(
                                                popUpLinkQuestion.toList()[index],
                                              ),
                                              labelStyle: GoogleFonts.getFont('Roboto Slab',
                                                  color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                              onDeleted: () {
                                                popUpLinkQuestion.remove(popUpLinkQuestion.toList()[index]);
                                                popUpLinkIDs.remove(popUpLinkIDs.toList()[index]);
                                                setState(() {});
                                              },
                                              deleteIcon: AppIconsRepo.deleteForeverIcon,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const Center(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: onTapGalleryService,
                                  child: AppIconsRepo.photoThemeIcon,
                                ),
                                KSizedBox.sizeWidthThirty,
                                InkWell(
                                  onTap: onTapCameraService,
                                  child: AppIconsRepo.photoCameraThemeIcon,
                                ),
                                KSizedBox.sizeWidthTwenty,
                                PopupMenuButton(
                                  icon: AppIconsRepo.linksThemeIcon,
                                  initialValue: dropDownValuePop,
                                  onSelected: (data) {
                                    dropDownValuePop = data;
                                    setState(() {});
                                  },
                                  itemBuilder: (context) {
                                    return List.generate(
                                      popMenuQaData.length,
                                      (index) => PopupMenuItem(
                                        value: index,
                                        onTap: () {
                                          popUpEnable = true;
                                          popUpLinkQuestion.add(popMenuQaData[index].get('questions'));
                                          popUpLinkIDs.add(popMenuQaData[index].id);
                                          // var id = popDataList[index].get('questionID').toString();
                                          // print("id for linking ids: ${popUpLinkIDs} ");
                                          // print("id for linking : ${popUpLinkQuestion} ");
                                          setState(() {});
                                        },
                                        child: Text(popMenuQaData[index].get('questions')),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: MeasurementRepo.edgeSymmetricAllTen,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' Description : ',
                                    style:
                                        GoogleFonts.getFont('Roboto Slab', fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  KSizedBox.sizeHeightThirty,
                                  TextFormField(
                                    controller: descText,
                                    style: GoogleFonts.getFont(
                                      'Roboto Slab',
                                      color: Colors.black,
                                    ),
                                    maxLength: 150,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      labelStyle: GoogleFonts.getFont(
                                        'Roboto Slab',
                                        color: MyColorsModal.kThemeColor,
                                      ),
                                      labelText: 'Description',
                                      hintText: 'Write a description here...',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            KSizedBox.sizeHeightTen,
                            Center(
                              child: RawMaterialButton(
                                elevation: 5.0,
                                constraints: const BoxConstraints(maxWidth: 120, minHeight: 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                fillColor: MyColorsModal.kThemeColor,
                                onPressed: () {
                                  try {
                                    if (answerList.isNotEmpty && descText.text.isNotEmpty) {
                                      // print(' @@@ widget.queryQuestionData.id : ${widget.queryQuestionData.id}');
                                      //answerList = [stepText.text];
                                      // print('@@## answerList list data : $answerList ');
                                      FirebaseFirestore.instance
                                          .collection('q&a')
                                          .doc(widget.queryQuestionData.id)
                                          .update({
                                        'answer': answerList,
                                        'description': descText.text,
                                        'links': popUpLinkIDs.toList(),
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Would you like to proceed?',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.getFont('Roboto Slab', fontSize: 16.0),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'OK',
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
                                                    'CANCEL',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: MyColorsModal.kThemeColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      // print('## answerList and descText.text has empty so please fill all required fields : $answerList ');
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Please fill up all fields because steps and description are empty.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.getFont('Roboto Slab', fontSize: 16.0),
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
                                                      color: MyColorsModal.kThemeColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  } catch (e) {
                                    // print('Error occurred in the add query submit button : $e');
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont(
                                        'Roboto Slab',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    KSizedBox.sizeWidthFifteen,
                                    AppIconsRepo.arrowRightIcon,
                                  ],
                                ),
                              ),
                            ),
                            KSizedBox.sizeHeightThirty,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapCameraGalleryService(ImageSource source) async {
    height += 150;
    var image = await picker.pickImage(source: source);
    if (image == null) return;
    setState(() {
      isUpload = true;
    });
    uploadIndex.add(answerList.length);
    var filePath = widget.queryQuestionData['categoryID'];
    var filePathId = widget.queryQuestionData['questionID'];
    // print('----- uploadIndex  && filePath----- filePathId : $uploadIndex  && $filePath && $filePathId');
    // print('## @@ image!.path answerFields list widget : ${image.path} ');
    answerFields.add(TextEditingController());
    setState(() {
      answerList.add('https://assets6.lottiefiles.com/packages/lf20_b88nh30c.json');
    });
    try {
      var date = await image.lastModified();
      var storageRef = storage.ref();
      // print('----- storageRef ----- : $storageRef');
      final String imageName = '$filePath/questionID_$filePathId/store_$date';
      var ref = storageRef.child(imageName);
      // print('----- ref ----- : $ref');
      // TaskSnapshot uploadImage =
      await ref.putFile(File(image.path));
      // print('----- uploadImage ----- : $uploadImage');
      var urlImage = await ref.getDownloadURL();
      answerList.removeAt(answerList.length - 1);
      setState(() {
        answerList.insert(answerList.length, urlImage);
        //height += 50;
      });
      // print('----- answerList ----- : $answerList');
    } catch (e) {
      // print('upload task FirebaseException : $e ');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Please try again later : $e',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont('Roboto Slab', fontSize: 16.0),
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
                    color: MyColorsModal.kThemeColor,
                  ),
                ),
              )
            ],
          );
        },
      );
    }
    // print('image!.path answerList @@@ step text : $answerList');
    //Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCollectionPage()));
  }

  void onTapCameraService() => _onTapCameraGalleryService(ImageSource.camera);

  void onTapGalleryService() => _onTapCameraGalleryService(ImageSource.gallery);
}
