import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../key/key_showcase.dart';
import '../../modal/color_modal.dart';
import 'drawer_listview.dart';

class CustomDrawerView extends StatelessWidget {
  const CustomDrawerView(
      {Key? key, required this.onPressedCloseIcon, required this.profileName})
      : super(key: key);

  final VoidCallback onPressedCloseIcon;
  final String profileName;

  // ShowCaseKeys showCaseKeys = ShowCaseKeys();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onPressedCloseIcon,
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                color: MyColorsModal.kThemeColor,
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: -10,
                      child: Showcase(
                        key: ShowCaseKeys.one,
                        description: "Click to close the drawer",
                        onTargetClick: () {
                          Future.delayed(const Duration(milliseconds: 50),
                              onPressedCloseIcon);
                          ShowCaseWidget.of(context).startShowCase([ShowCaseKeys.two, ShowCaseKeys.four]);
                        },
                        disposeOnTap: true,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.clear_circled),
                          onPressed: onPressedCloseIcon,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: Column(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            minRadius: 20,
                            maxRadius: 30,
                            child: Icon(
                              CupertinoIcons.profile_circled,
                              size: 50,
                              color: MyColorsModal.kThemeColor,
                            ),
                          ),
                          Text(
                            profileName,
                            style: GoogleFonts.getFont('Roboto Slab',
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DrawerItemsListView(
                profileName: profileName,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
