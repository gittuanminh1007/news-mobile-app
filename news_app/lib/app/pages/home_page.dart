import 'package:flutter/material.dart';
import 'package:news_app/app/pages/account_page.dart';
import 'package:news_app/app/pages/cupertino_home_scaffold.dart';
import 'package:news_app/app/pages/news_page.dart';
import 'package:news_app/app/pages/setting_page.dart';
import 'package:news_app/app/pages/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.news;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.news: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
    TabItem.setting: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.news: (_) => NewsPage(),
      TabItem.account: (_) => AccountPage(),
      TabItem.setting: (_) => Container(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
