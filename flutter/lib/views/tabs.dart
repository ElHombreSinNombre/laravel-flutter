import 'package:flutter/material.dart';
import 'package:map/views/tabs/map.dart';
import '/views/tabs/user.dart';
import '/views/form.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _index = 0;
  final List<Widget> _children = [
    const MapPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Users',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPage(),
            ),
          );
        },
        tooltip: 'New user',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _index = value;
    });
  }
}
