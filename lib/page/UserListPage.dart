import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter/graphql/QueryMutation.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/service/AuthService.dart';
import 'package:test_flutter/service/GraphqlService.dart';

class UserListPage extends StatefulWidget {
  UserListPage();

  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  VoidCallback refetchQuery;
  static List<LazyCacheMap> users;
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _corpIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    print("dispose() of UserListPage");
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("USER LIST"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          LazyCacheMap user;
          _createDataDialog(user);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Query(
        options: QueryOptions(
          documentNode: gql(QueryMutation.fetchUser),
        ),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          refetchQuery = refetch;
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.loading) {
            return Text('Loading');
          }
          users =
              (result.data['getUsers'] as List<dynamic>).cast<LazyCacheMap>();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              dynamic responseData = users[index];
              var id = responseData["userId"];
              var userName = responseData.data['userName'];
              var date = new DateTime.fromMicrosecondsSinceEpoch(
                1000 * int.parse(responseData['createdDate']),
              );
              var corpData = {
                "corpId": responseData['corpId']['corpId'],
                "corpName": responseData['corpId']['corpName'],
                "corpContactNumber": responseData['corpId']
                    ['corpContactNumber'],
              };
              return ListTile(
                title: Text("USER ID : $id"),
                subtitle: Text("$userName"),
                trailing: Text("$date"),
                onTap: () {
                  _userDataDialog(corpData, id, users, index);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _createDataDialog(LazyCacheMap user) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("create User"),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "userId"),
                    controller: _userIdController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "userName"),
                    controller: _userNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "corpId"),
                    controller: _corpIdController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "password"),
                    controller: _passwordController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_userIdController.text.isNotEmpty) {
                      GraphqlService.createUserService(
                          _userIdController.text,
                          _userNameController.text,
                          _corpIdController.text,
                          _passwordController.text);
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Create")),
              FlatButton(
                  onPressed: () {
                    _userIdController.clear();
                    _userNameController.clear();
                    _corpIdController.clear();
                    _passwordController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  void _userDataDialog(
      var corpData, String id, List<LazyCacheMap> users, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("User Corparation Information"),
          content: new Text(
              "Corparation ID : ${corpData['corpId']} \nCorparation Name : ${corpData['corpName']} \nCorparation Contact :  ${corpData['corpContactNumber']}"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("delete"),
              onPressed: () {
                GraphqlService.deleteUserService(id);
                setState(() {
                  users.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
