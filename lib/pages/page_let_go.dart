import 'package:flutter/material.dart';
import 'package:multiads/multiads.dart';
import 'package:player/app_theme.dart';
import 'package:player/constants.dart';
import 'package:player/darwer/drawer.dart';
import 'package:player/database/helper.dart';
import 'package:player/database/modeldata.dart';
import 'package:player/pages/page_add_url.dart';
import 'package:player/pages/page_resultat.dart';

class PageLetGo extends StatefulWidget {
  const PageLetGo({Key? key}) : super(key: key);

  @override
  _PageLetGoState createState() => _PageLetGoState();
}

class _PageLetGoState extends State<PageLetGo> {
  @override
  initState() {
    super.initState();
    refreshData();
  }

  late List<DataModel> data;
  bool isLoading = false;

  Future refreshData() async {
    setState(() => isLoading = true);
    data = await HelperDatabase.instance.readAllData();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (configApp["showAlertRating"] == true) showRatting(context);
    // });
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(configApp["name"]),
      ),
      drawer: ftDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nativeOrBanner(),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                letGo(context),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget letGo(BuildContext context) {
    double _widthScreen = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: _widthScreen * 0.8,
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          color: AppTheme.primary,
          //border: Border.all(width: 2, color: AppTheme.colorBorder),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          if (data.isEmpty) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PageAddUrl()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PageResulta()));
          }
          g_ads.interInstance.showInterstitialAd();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Start   ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorText),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.move_to_inbox,
              size: 30,
              color: AppTheme.colorIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget nativeOrBanner() {
    if (configApp["nativeOrbanner"] == "native") {
      return g_ads.nativeInstance.getNativeAdWidget();
    } else if (configApp["nativeOrbanner"] == "banner") {
      return CustomBanner(key: UniqueKey(), ads: g_ads.bannerInstance);
    }
    return Container();
  }
}
