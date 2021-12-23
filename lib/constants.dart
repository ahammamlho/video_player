import 'package:multiads/multiads.dart';

class Constants {
  static const jsonConfigUrl =
      'https://drive.google.com/uc?export=download&id=1v9V8MTVktF3O4_g8R1sohSBPBxk9faDb';
}

late Map<String, dynamic> configApp;
late final MultiAds g_ads;

willPopCallback() async {
  if (configApp["lhak"] == "oui") {
    g_ads.interInstance.showInterstitialAd();
  }
}
