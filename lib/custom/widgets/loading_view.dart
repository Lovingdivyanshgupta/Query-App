import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:query_app/constants/measurement_repo.dart';
import 'package:query_app/modal/color_modal.dart';

class LoadingDataView extends StatelessWidget {
  const LoadingDataView({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: MeasurementRepo.edgeAllFifteen,
            child: const Center(
              child: CircularProgressIndicator(
                color: MyColorsModal.kThemeColor,
              ),
            ),
          ),
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
