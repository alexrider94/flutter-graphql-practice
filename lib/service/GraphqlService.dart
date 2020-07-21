import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  static final HttpLink httpLink =
      HttpLink(uri: "http://10.1.42.224:5556/graphql");

  static final _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMDIiLCJpYXQiOjE1OTUyMTAzMDksImV4cCI6MTU5NTgxNTEwOX0.F1zTLAtktByV0rFaPpWjFnlcEEYjIKeE-QB7oI5P5lw";
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
