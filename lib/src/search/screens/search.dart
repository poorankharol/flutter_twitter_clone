import 'package:flutter/material.dart';

import '../../../core/constants/appcolors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  Widget textWidget(String text){
    return Center(child: Text(text,style: TextStyle(fontSize: 24),));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorColor: AppColors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            isScrollable: true,
            unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            labelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(
                child: Text(
                  "For you",
                ),
              ),
              Tab(
                child: Text(
                  "Trending",
                ),
              ),
              Tab(
                child: Text(
                  "News",
                ),
              ),
              Tab(
                child: Text(
                  "Sports",
                ),
              ),
              Tab(
                child: Text(
                  "Entertainment",
                  style:
                  TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            textWidget('Nothing to see here yet.'),
            textWidget('Nothing to see here yet.'),
            textWidget('Nothing to see here yet.'),
            textWidget('Nothing to see here yet.'),
            textWidget('Nothing to see here yet.'),
          ],
        ),
      ),
    );
  }
}
