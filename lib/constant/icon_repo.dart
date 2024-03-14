import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modal/color_modal.dart';

class AppIconsRepo {
  static Icon pencilBlackIcon = const Icon(
    CupertinoIcons.pencil,
    color: Colors.black,
  );

  static Icon deleteSweepBlackIcon = const Icon(
    Icons.delete_sweep,
    color: Colors.black,
  );

  static Icon searchIcon = const Icon(
    Icons.search,
  );

  static Icon addBoxIcon = const Icon(
    Icons.add_box,
    size: 30.0,
  );

  static Icon filterIcon = const Icon(Icons.filter_list);

  static Icon arrowRightIcon = const Icon(
    Icons.arrow_right,
    color: Colors.white,
  );

  static Icon deleteForeverIcon = const Icon(
    Icons.delete_forever_rounded,
    color: Colors.white,
  );

  static Icon removeCircleIcon = const Icon(
    Icons.remove_circle_outline_rounded,
    size: 30,
    color: MyColorsModal.kThemeColor,
  );

  static Icon photoThemeIcon = const Icon(
    CupertinoIcons.photo,
    size: 30,
    color: MyColorsModal.kThemeColor,
  );

  static Icon photoCameraThemeIcon = const Icon(
    CupertinoIcons.photo_camera,
    size: 30,
    color: MyColorsModal.kThemeColor,
  );
  static Icon linksThemeIcon = const Icon(
    CupertinoIcons.link,
    size: 30,
    color: MyColorsModal.kThemeColor,
  );

  static Icon profileBlackIcon = const Icon(
    CupertinoIcons.profile_circled,
    color: Colors.black,
    size: 80,
  );

  static Icon settingIcon = const Icon(Icons.settings_rounded);
  static Icon chevronRightIcon = const Icon(Icons.chevron_right);
  static Icon infoIcon = const Icon(CupertinoIcons.info);
  static Icon eyeFillIcon = const Icon(CupertinoIcons.eye_fill);
  static Icon eyeSlashIcon = const Icon(CupertinoIcons.eye_slash);
}
