import 'package:flutter/material.dart';
import '../../endpoints/user.dart';
import '../../models/user.dart';
import '../../views/form.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<List<UserModel>> _futureUsers;

  @override
  void initState() {
    super.initState();
    getValue().then((_) => WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text('Dismiss to delete'),
              ),
              duration: Duration(seconds: 6),
            ),
          );
        }));
  }

  Future<void> getValue() async {
    _futureUsers = UserService().getAll();
  }

  @override
  Widget build(BuildContext context) {
    final userList = FutureBuilder<List<UserModel>>(
      future: _futureUsers,
      builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          final userList = snapshot.data!;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final item = userList[index];
              return Dismissible(
                key: Key(item.id.toString()),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  UserService().delete(item.id!).then((_) {
                    setState(() {
                      userList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text('${item.name} deleted'),
                        ),
                        duration: const Duration(seconds: 6),
                      ),
                    );
                  });
                },
                background: Container(
                  alignment: AlignmentDirectional.centerStart,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPage(id: item.id),
                      ),
                    );
                  },
                  leading: const Icon(Icons.person),
                  title: Text(item.name),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: userList,
        ),
      ),
    );
  }
}
