import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/measurement_repo.dart';
import '../../modal/color_modal.dart';

class LoadingDataView extends StatelessWidget {
  const LoadingDataView({Key? key, required this.text, this.isShowLoader}) : super(key: key);

  final String text;
  final bool? isShowLoader;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (isShowLoader ?? false) ? Padding(
            padding: MeasurementRepo.edgeAllFifteen,
            child: const Center(
              child: CircularProgressIndicator(
                color: MyColorsModal.kThemeColor,
              ),
            ),
          ) : const SizedBox(),
          Image.asset("assets/images/no_record.png",width: 200,height: 200,),
          Text(
            text,
            style: GoogleFonts.getFont(
              'Roboto Slab',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
