import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/icon_repo.dart';
import '../constant/measurement_repo.dart';
import '../constant/sizedbox_constants.dart';
import '../modal/color_modal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.profileName}) : super(key: key);

  final String profileName;

  final String? profileId = '123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          "Profile",
          style: GoogleFonts.getFont("Roboto Slab", color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: MyColorsModal.kThemeColor,
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: 5,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                minRadius: 50,
                maxRadius: 60,
                child: CircleAvatar(
                  backgroundColor: MyColorsModal.kThemeColor,
                  minRadius: 45,
                  maxRadius: 55,
                  child: AppIconsRepo.profileBlackIcon,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: MeasurementRepo.edgeSymmetricTwentyThirty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Name",
                    style: GoogleFonts.getFont(
                      "Roboto Slab",
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: MeasurementRepo.edgeAllTen,
                    color: Colors.grey.shade300,
                    child: Text(
                      profileName,
                      style: GoogleFonts.getFont(
                        "Roboto Slab",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  KSizedBox.sizeHeightTwenty,
                  Text(
                    "Code",
                    style: GoogleFonts.getFont(
                      "Roboto Slab",
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: MeasurementRepo.edgeAllTen,
                    color: Colors.grey.shade300,
                    child: Text(
                      "IC9163",
                      style: GoogleFonts.getFont(
                        "Roboto Slab",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  KSizedBox.sizeHeightTwenty,
                  const Divider(
                    thickness: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
