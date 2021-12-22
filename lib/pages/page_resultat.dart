import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:player/app_theme.dart';
import 'package:player/darwer/drawer.dart';
import 'package:player/database/helper.dart';
import 'package:player/database/modeldata.dart';
import 'package:player/pages/page_add_url.dart';

class PageResulta extends StatefulWidget {
  const PageResulta({Key? key}) : super(key: key);

  @override
  _PageResultaState createState() => _PageResultaState();
}

class _PageResultaState extends State<PageResulta> {
  late List<DataModel> data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future refreshData() async {
    setState(() => isLoading = true);
    data = await HelperDatabase.instance.readAllData();
    setState(() => isLoading = false);
  }

  // @override
  // void dispose() {
  //   HelperDatabase.instance.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("ytv player"),
        backgroundColor: AppTheme.primary,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PageAddUrl()));
                },
                icon: const Icon(FontAwesomeIcons.plus)),
          ),
        ],
      ),
      drawer: ftDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? const Center(
                  child: Text(
                  'No Data',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
              : buildData(),
    );
  }

  Widget buildData() {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: ListTile(
                title: Text(data[index].title),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getTime(data[index].createdTime)),
                    ((data[index].user).isEmpty)
                        ? Container()
                        : Text(data[index].user),
                  ],
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        "assets/img5.png",
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppTheme.primary,
                    ),
                    onPressed: () async {
                      await HelperDatabase.instance.delete(data[index]);
                      setState(() {
                        refreshData();
                      });
                    })),
          );
        });
  }

  String _getTime(DateTime now) {
    final String formattedDateTime =
        DateFormat('kk:mm  dd/MM/yyyy').format(now).toString();
    return formattedDateTime;
  }
}
