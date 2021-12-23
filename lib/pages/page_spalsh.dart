import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multiads/multiads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
    ftProgre();
  }

  double progre = 0.0;
  int nbr = 1;
  String txt = ".";
  bool isReady = false;
  late Timer timer;

  ftProgre() {
    timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (timer) {
        setState(() {
          if ((progre < 0.7 || isReady) && progre <= 1) {
            progre = progre + 0.08;
          }
          if (nbr == 1) {
            txt = ".  ";
          } else if (nbr == 2) {
            txt = ".. ";
          } else {
            txt = "...";
            nbr = 0;
          }
          nbr++;
        });
        if (isReady && progre > 1) {
          isReady = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PageLetGo()));
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
              "Loading $txt",
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
      initOneSignall();
      var url = Uri.parse(Constants.jsonConfigUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        g_ads = MultiAds(response.body);
        await g_ads.init();
        g_ads.interInstance.loadInterstitialAd();
        g_ads.nativeInstance.loadRewardAd();
        Map<String, dynamic> data2 = json.decode(response.body);
        configApp = data2["config"];
        setState(() {
          isReady = true;
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

  initOneSignall() async {
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }
    await OneSignal.shared.setAppId("20866794-d7a6-42af-8c59-c7b4d253e236");
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }
}
