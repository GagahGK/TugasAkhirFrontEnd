import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:futurebuilder_example/page/devices_list.dart';

import 'package:futurebuilder_example/page/cluster/clusterHourly.dart';
import 'package:futurebuilder_example/page/user_local_page.dart';
import 'package:futurebuilder_example/page/settings_page.dart';

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
  int index = 2;
  TabBar bottomBar = null;
  @override
  Widget build(BuildContext context) => DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.title), bottom: bottomBar),
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
            onTap: _onTap,
          ),
          body: buildPages(),
        ),
      );

  void _onTap(int index) {
    if (index != this.index) {
      setState(() {
        this.index = index;
        switch (index) {
          case 1:
            bottomBar = TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.power),
                ),
                Tab(
                  icon: Icon(Icons.power),
                ),
                Tab(
                  icon: Icon(Icons.power),
                )
              ],
            );
            break;
          default:
            bottomBar = null;
        }
      });
    }
  }

  Widget buildPages() {
    // bottomNavBarPageBuilder
    switch (index) {
      case 0:
        return DeviceListPage();
      case 1:
        return TabBarView(
            children: [ClusterHourly(), ClusterHourly(), Container()]);
      case 2:
        return SettingsPage();
      default:
        return Container();
    }
  }
}
