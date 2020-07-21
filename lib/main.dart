import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter/graphql/QueryMutation.dart';
import 'package:test_flutter/service/GraphqlService.dart';

GraphqlService graphqlService = GraphqlService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GraphQLProvider(
      client: GraphqlService.client(),
      child: CacheProvider(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VoidCallback refetchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
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
          final List<LazyCacheMap> users =
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
                    _userDataDialog(corpData);
                  },
                );
              });
        },
      ),
    );
  }

  void _userDataDialog(var corpData) {
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
