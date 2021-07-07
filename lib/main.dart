import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:futurebuilder_example/page/devices_list.dart';

import 'package:futurebuilder_example/page/user_local_page.dart';
import 'package:futurebuilder_example/page/settings_page.dart';
import 'package:futurebuilder_example/page/user_network_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Future Builder & Json';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.teal,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: ('Devices'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: ('Cluster'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: ('Settings'),
            ),
          ],
          onTap: (int index) => setState(() => this.index = index),
        ),
        body: buildPages(),
      );

  Widget buildPages() {
    // bottomNavBarPageBuilder
    switch (index) {
      case 0:
        return DeviceListPage();
      case 1:
        return UserLocalPage();
      case 2:
        return SettingsPage();
      default:
        return Container();
    }
  }
}
