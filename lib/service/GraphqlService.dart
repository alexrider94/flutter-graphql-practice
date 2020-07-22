import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_flutter/graphql/QueryMutation.dart';

class GraphqlService {
  static var _token;
  static final HttpLink httpLink =
      HttpLink(uri: "http://10.1.42.224:5556/graphql");

  static setToken(String token) {
    _token = token;
  }

  static deleteToken() {
    _token = null;
  }

  static bool checkToken() {
    if (_token != null)
      return true;
    else
      return false;
  }

  static createUserService(
      String userId, String userName, String corpId, String password) {
    client()
        .value
        .mutate(MutationOptions(
            // ignore: deprecated_member_use
            document:
                QueryMutation.createUser(userId, userName, corpId, password)))
        .then((value) {
      return Fluttertoast.showToast(
          msg: "user created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  static deleteUserService(String userId) {
    client()
        .value
        .mutate(MutationOptions(
            // ignore: deprecated_member_use
            document: QueryMutation.deleteUser(userId)))
        .then((value) {
      return Fluttertoast.showToast(
          msg: "user deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  static final AuthLink authLink = AuthLink(getToken: () => _token);
  static final WebSocketLink websocketLink = WebSocketLink(
    url: 'http://10.1.42.224:5556/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      initPayload: {
        'headers': {'Authorization': _token},
      },
    ),
  );
  static final Link link = authLink.concat(httpLink).concat(websocketLink);

  static ValueNotifier<GraphQLClient> client() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: link,
      ),
    );
    return client;
  }
}
