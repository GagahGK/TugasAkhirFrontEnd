import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import classes
import 'package:futurebuilder_example/page/devicePage/deviceList.dart';
import 'package:futurebuilder_example/page/cluster/deviceCluster.dart';
import 'package:futurebuilder_example/page/cluster/devicesCluster.dart';
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
  static final String title = 'Monitoring Listrik';

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
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomNavBarIndex = 2;
  TabBar? bottomBar;
  @override
  Widget build(BuildContext context) => DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.title), bottom: bottomBar),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomNavBarIndex,
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
            onTap: _onTapClusterTab,
          ),
          body: buildBottomNavBarPages(),
        ),
      );

  void _onTapClusterTab(int index) {
    List<Tab> clusterTab = [
      Tab(
        icon: Icon(FluentIcons.clock_12_regular),
        text: "Hourly",
      ),
      Tab(
        icon: Icon(FluentIcons.calendar_3_day_16_regular),
        text: "Daily",
      ),
      Tab(
        icon: Icon(FluentIcons.calendar_month_20_regular),
        text: "Monthly",
      ),
      Tab(
        icon: Icon(FluentIcons.building_retail_20_regular),
        text: "Buildings",
      )
    ];

    if (index != this.bottomNavBarIndex) {
      setState(() {
        this.bottomNavBarIndex = index;
        switch (index) {
          case 1:
            bottomBar = TabBar(
              tabs: clusterTab,
            );
            break;
          default:
            bottomBar = null;
        }
      });
    }
  }

  Widget buildBottomNavBarPages() {
    // bottomNavBarPageBuilder
    switch (bottomNavBarIndex) {
      case 0:
        return DeviceListPage();
      case 1:
        return TabBarView(children: [
          DeviceCluster(category: 0),
          DeviceCluster(category: 1),
          DeviceCluster(category: 2),
          DevicesCluster()
        ]);
      case 2:
        return SettingsPage();
      default:
        return Container();
    }
  }
}
