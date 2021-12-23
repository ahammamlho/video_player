import 'package:flutter/material.dart';
import 'package:player/app_theme.dart';
import 'package:player/darwer/drawer.dart';
import 'package:player/database/helper.dart';
import 'package:player/database/modeldata.dart';
import 'package:player/pages/page_resultat.dart';
import 'package:player/toas.dart';

class PageAddUrl extends StatefulWidget {
  const PageAddUrl({Key? key}) : super(key: key);

  @override
  _PageAddUrlState createState() => _PageAddUrlState();
}

class _PageAddUrlState extends State<PageAddUrl> {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController userController = TextEditingController();
  String title = '';
  String url = '';
  String user = '';
  var now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text("Add URL"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PageResulta()));
                },
                icon: const Icon(
                  Icons.read_more,
                  size: 35,
                )),
          ),
        ],
      ),
      drawer: ftDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          fieldText("Title", titleController, 1),
          fieldText("URL", urlController, 2),
          fieldText("User Agent", userController, 3),
          buttonSave(context)
        ],
      ),
    );
  }

  Widget fieldText(String txt, TextEditingController controller, int i) {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextField(
          controller: controller,
          cursorColor: AppTheme.primary,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary),
                borderRadius: BorderRadius.circular(10.0),
              ),
              // enabledBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red),
              // ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary),
              ),
              labelText: txt,
              labelStyle: TextStyle(color: AppTheme.colorText)),
          onChanged: (text) {
            setState(() {
              if (i == 1) {
                title = text;
              } else if (i == 2) {
                url = text;
              } else {
                user = text;
              }
            });
          },
        ));
  }

  Widget buttonSave(BuildContext context) {
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
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const PageAddUrl()));
          addUrl();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SAVE",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorText),
            ),
            const SizedBox(width: 15),
            Icon(
              Icons.save,
              size: 30,
              color: AppTheme.colorIcon,
            ),
          ],
        ),
      ),
    );
  }

  Future addUrl() async {
    if (title.isEmpty) {
      toas(context, ' Please enter title ');
    } else {
      if (hasValidUrl(url)) {
        now = DateTime.now();
        final data = DataModel(
          title: title,
          url: url,
          user: user,
          createdTime: now,
        );
        await HelperDatabase.instance.create(data);
        setState(() {
          title = '';
          url = '';
          user = '';
          titleController.text = "";
          urlController.text = "";
          userController.text = "";
        });
        toas(context, ' Saved ');
      }
    }
  }

  bool hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      toas(context, ' Please enter url ');
      return false; //'Please enter url';
    } else if (!regExp.hasMatch(value)) {
      toas(context, ' Please enter valid url ');
      return false; //'Please enter valid url';
    }
    return true;
  }
}
