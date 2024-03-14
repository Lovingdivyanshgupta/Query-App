import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../constant/measurement_repo.dart';
import '../constant/sizedbox_constants.dart';
import '../custom/paint/custom_paint.dart';
import '../fcm/firebase_repo.dart';
import '../modal/color_modal.dart';

class AnswerWindowScreen extends StatefulWidget {
  const AnswerWindowScreen({super.key, required this.answerData});

  final QueryDocumentSnapshot answerData;

  @override
  State<AnswerWindowScreen> createState() => _AnswerWindowScreenState();
}

class _AnswerWindowScreenState extends State<AnswerWindowScreen> {
  final colorGradient = MyColorsModal();
  final panelController = PanelController();
  Map<String, dynamic> linkIdData = {};
  String linkQuestion = '';

  Future<Map<String, dynamic>> getDocumentData(String pathDoc) async {
    final FirebaseFirestore fire = FirebaseFirestore.instance;
    var data = await fire.collection('q&a').doc('/$pathDoc').get();
    // print("doc data : $data");
    // print("doc data : ${data.data()}");
    return data.data()!;
  }

  @override
  Widget build(BuildContext context) {
    List answerTile = widget.answerData['answer'];
    String answerDesc = widget.answerData['description'];
    return Scaffold(
      backgroundColor: Colors.grey, //colorGradient.getGradientColors()[1].colors[1],
      body: Container(
        //color: Colors.redAccent,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/background_3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SlidingUpPanel(
          minHeight: 50.0,
          maxHeight: 200.0,
          backdropEnabled: true,
          backdropColor: Colors.black,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          controller: panelController,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
          padding: MeasurementRepo.edgeAllTwenty,
          panelBuilder: (scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    (panelController.isPanelOpen) ? panelController.close() : panelController.open();
                  },
                  child: Container(
                    width: 50.0,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                KSizedBox.sizeHeightThirty,
                Text(
                  'About',
                  style: GoogleFonts.getFont('Roboto Slab', fontSize: 20.0),
                ),
                KSizedBox.sizeHeightTen,
                Text(
                  answerDesc.toString(),
                  style: GoogleFonts.getFont('Roboto Slab', fontSize: 16.0),
                ),
              ],
            );
          },
          body: CustomPaint(
            painter: CurvePaint(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KSizedBox.sizeHeightThirty,
                Padding(
                  padding: MeasurementRepo.edgeAllFive,
                  child: Row(
                    children: [
                      const BackButton(
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            widget.answerData['questions'].toString(),
                            style: GoogleFonts.getFont('Roboto Slab',
                                fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: MeasurementRepo.edgeOnlyTen,
                    child: Container(
                      padding: MeasurementRepo.edgeAllEight,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // image: DecorationImage(
                          //   image: AssetImage("assets/images/background.png"),
                          //   fit: BoxFit.fitWidth,
                          //   alignment: Alignment.topLeft
                          // ),
                          border: Border.all(width: 0.6),
                          boxShadow: const [
                            BoxShadow(color: Colors.black87, blurRadius: 30, offset: Offset(0, -10)),
                          ],
                          borderRadius: BorderRadius.circular(20.0)),
                      child: ListView.builder(
                        itemCount: answerTile.length,
                        padding: MeasurementRepo.edgeOnlyBottomFifty,
                        itemBuilder: (context, index) {
                          //print('@@@ MediaQuery size :  ${MediaQuery.of(context).size.width}');
                          return Padding(
                            padding: MeasurementRepo.edgeOnlyTopBottomTen,
                            child: Row(
                              children: [
                                const Column(
                                  children: [
                                    Text(
                                      '|',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    Icon(
                                      CupertinoIcons.circle,
                                      size: 18.0,
                                      color: Colors.red,
                                      fill: 0.9,
                                      weight: 0.9,
                                    ),
                                    Text(
                                      '|',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '-',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: MeasurementRepo.edgeAllTen,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      //border: Border.all(width: 0.8, color: Colors.black87),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey,
                                      //       offset: Offset(5, 5)),
                                      // ],
                                      gradient: MyColorsModal.cardGradientColors()[index % 6],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: (answerTile[index].toString().startsWith('https'))
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, _, __) {
                                                    return ImageDetailScreen(
                                                      url: answerTile[index],
                                                      question: widget.answerData['questions'].toString(),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Image.network(
                                              answerTile[index],
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : (answerTile[index].toString().contains(RegExp('Follow the link below.')))
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${answerTile[index]}',
                                                    style: GoogleFonts.getFont(
                                                      'Roboto Slab',
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  linksWidget(),
                                                ],
                                              )
                                            : Text(
                                                '${answerTile[index]}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.getFont(
                                                  'Roboto Slab',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget linksWidget() {
    List<dynamic> answerLinks = widget.answerData['links'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        answerLinks.length,
        (index) => FutureBuilder(
          future: getDocumentData(answerLinks[index]),
          builder: (context, snap) {
            if (snap.hasData) {
              linkQuestion = snap.data!['questions'];
              return InkWell(
                onTap: () async {
                  // print("answer links :${answerLinks[index]}");
                  final fire = await FireBaseDataBaseRepo().getDocsList('q&a');

                  for (QueryDocumentSnapshot<Object?> element in fire) {
                    // print('element : ${element.id}');
                    if (element.id == answerLinks[index]) {
                      // print('element id : ${element.id}');
                      // var isNavigate = element.get('answer');
                      // print('navi : $isNavigate');
                      if (element.get('answer').toString().isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnswerWindowScreen(
                              answerData: element,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Column(
                              children: [
                                Text('Warning: Cannot navigate due to empty data.'),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text('Do you want to edit ?'),
                                //     IconButton(
                                //       onPressed: () {},
                                //       icon: Icon(
                                //         Icons.check,
                                //         color: Colors.green,
                                //       ),
                                //     ),
                                //     IconButton(
                                //       onPressed: () {
                                //
                                //       },
                                //       icon: Icon(
                                //         Icons.close,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(
                  linkQuestion.toString(),
                  style: GoogleFonts.getFont(
                    'Roboto Slab',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo,
                    decoration: TextDecoration.underline,
                  ),
                ),
              );
            }
            return const Center();
          },
        ),
      ),
    );
  }
}
