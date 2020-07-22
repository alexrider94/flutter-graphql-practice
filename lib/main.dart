import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter/page/LoginPage.dart';
import 'package:test_flutter/page/UserListPage.dart';
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
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => UserListPage(),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   VoidCallback refetchQuery;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("User List"),
//         ),
//         body: UserListPage());
//   }
// }
