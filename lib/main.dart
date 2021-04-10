import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:jc_scanner/scan.dart';
import 'package:jc_scanner/generate.dart';
import 'package:jc_scanner/settings.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
    // home: Home()
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      ScanPage(),
      GeneratePage(),
      SettingsPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner),
        title: ("Scan"),
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code),
        title: ("Create"),
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Seetings"),
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}


