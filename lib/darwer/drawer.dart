import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:player/app_theme.dart';
import 'package:player/constants.dart';
import 'package:player/pages/page_let_go.dart';
import 'package:player/utils.dart';

Widget ftDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      color: AppTheme.primary,
      child: ListView(
          padding: const EdgeInsets.only(top: 90),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                backgroundImage: AssetImage("assets/img5.png"),
                radius: 58,
              ),
            ),
            drawer(FontAwesomeIcons.home, "Home", () {
              home(context);
            }),
            drawer(Icons.star_rate, "Rate App", linkRate),
            drawer(FontAwesomeIcons.googlePlay, "Others Apps", linkDeveloper),
            drawer(Icons.mail, "Send suggestions", linkEmail),
            drawer(Icons.policy, "Privacy Policy", linkPolicy),
          ]),
    ),
  );
}

//
home(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PageLetGo()));
}

linkRate() {
  Utils.openLink(
      url:
          'http://play.google.com/store/apps/details?id=${configApp["package"]}');
}

linkDeveloper() {
  Utils.openLink(url: '${configApp["developer"]}');
}

linkEmail() {
  Utils.openEmail(
      toEmail: configApp["email"], subject: "suggestion for devLho", body: " ");
}

linkPolicy() {
  Utils.openLink(url: configApp["policy"]);
}

Widget drawer(IconData icon, String txt, Function fct) {
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
    decoration: BoxDecoration(
        color: AppTheme.colorListTile,
        borderRadius: const BorderRadius.all(Radius.circular(30))),
    child: ListTile(
      leading: Icon(
        icon,
        color: AppTheme.colorIcon,
      ),
      title: Text(
        txt,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: AppTheme.colorText),
      ),
      onTap: () {
        fct();
      },
      focusColor: Colors.red,
    ),
  );
}
