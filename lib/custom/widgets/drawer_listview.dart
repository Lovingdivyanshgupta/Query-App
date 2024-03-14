import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../constant/icon_repo.dart';
import '../../key/key_showcase.dart';
import '../../preferences/my_shared_preferences.dart';
import '../../screens/login_screen.dart';

class DrawerItemsListView extends StatefulWidget {
  const DrawerItemsListView({Key? key, required this.profileName})
      : super(key: key);

  final String profileName;

  @override
  State<DrawerItemsListView> createState() => _DrawerItemsListViewState();
}

class _DrawerItemsListViewState extends State<DrawerItemsListView> {
  bool? isLogin;

  final List<String> drawerItems = ["Profile", "How to use ?", "Login"];

  final List<IconData> drawerItemsIcon = [
    CupertinoIcons.profile_circled,
    CupertinoIcons.question_circle,
    Icons.login,
  ];

  // ShowCaseKeys showCaseKeys = ShowCaseKeys();

  void getLoginData() async {
    isLogin = await MySharedPreferences.getUserDefault('userLogin');
    if (isLogin!) {
      setState(() {
        drawerItems.last = "Logout";
        drawerItemsIcon.last = Icons.logout;
      });
      // print("drawer items : $drawerItems");
      // print("drawer items icon: $drawerItemsIcon");
    }
  }

  @override
  void initState() {
    getLoginData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: drawerItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(drawerItems[index]),
            leading: Icon(drawerItemsIcon[index]),
            trailing: AppIconsRepo.chevronRightIcon,
            onTap: () async {
              // print("object : $index");
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      profileName: widget.profileName,
                    ),
                  ),
                );
              } else if (index == 1) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ShowCaseWidget.of(context).startShowCase(
                    [
                      ShowCaseKeys.one,
                      ShowCaseKeys.two,
                      ShowCaseKeys.four,
                    ],
                  ),
                );
                ShowCaseKeys.isShowcase = true;
              } else if (index == 2) {
                Navigator.pushNamed(context, LoginPage.id);
                await MySharedPreferences.setUserDefault(
                    'userLogin', !isLogin!);
              }
            },
          );
        },
      ),
    );
  }
}
