import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:player/app_theme.dart';
import 'package:player/constants.dart';
import 'package:player/pages/page_let_go.dart';

class PageSpalsh extends StatefulWidget {
  const PageSpalsh({Key? key}) : super(key: key);

  @override
  _PageSpalshState createState() => _PageSpalshState();
}

class _PageSpalshState extends State<PageSpalsh> {
  @override
  void initState() {
    super.initState();
    fetchAdsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: AppTheme.primary,
                color: AppTheme.colorIcon,
                strokeWidth: 8,
              ),
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            Text(
              "Loading ...",
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colorText),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAdsData() async {
    try {
      var url = Uri.parse(Constants.jsonConfigUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data2 = json.decode(response.body);
        configApp = data2["config"];
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PageLetGo()));
        });
      } else {
        await Future.delayed(const Duration(seconds: 5), () {
          fetchAdsData();
        });
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5), () {
        fetchAdsData();
      });
    }
  }

  // initOneSignall() async {
  //   if (kDebugMode) {
  //     OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  //   }
  //   await OneSignal.shared.setAppId("f20e20a4-e395-4aa2-a252-83de4e14e9a0");
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  //   OneSignal.shared
  //       .promptUserForPushNotificationPermission()
  //       .then((accepted) {});
  // }
}
