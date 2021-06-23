import 'package:flutter/material.dart';

enum TabItem { news, account, setting }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.news: TabItemData(title: 'News', icon: Icons.article),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
    TabItem.setting: TabItemData(title: 'Setting', icon: Icons.settings),
  };
}