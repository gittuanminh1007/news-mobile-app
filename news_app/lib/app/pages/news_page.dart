import 'dart:core';

import 'package:flutter/material.dart';
import 'package:news_app/app/pages/tab_view.dart';
import 'package:news_app/services/api_service.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabList = [
    Tab(
      child: Text('News'),
    ),
    Tab(
      child: Text('Global'),
    ),
    Tab(
      child: Text('Business'),
    ),
    Tab(
      child: Text('Entertainment'),
    ),
    Tab(
      child: Text('Law'),
    ),
    Tab(
      child: Text('Health'),
    ),
    Tab(
      child: Text('Education'),
    ),
  ];

  final List<String> items = <String>[
    'All',
    'Tuổi trẻ',
    'VNExpress',
    'Zing News'
  ];
  String selectedItem = 'All';

  TabController _tabController;

  ApiService client = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        centerTitle: true,
        title: Image.asset(
          'images/logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: Colors.green,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              controller: _tabController,
              tabs: _tabList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Source: ',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  DropdownButton<String>(
                    value: selectedItem,
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepOrange),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TabView(
                  client: client,
                  type: 'new',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'global',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'business',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'entertaiment',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'law',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'health',
                  selectedItem: selectedItem,
                ),
                TabView(
                  client: client,
                  type: 'edu',
                  selectedItem: selectedItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
