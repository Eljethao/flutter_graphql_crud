import 'package:flutter_graphql_crud/graphql/query.dart';
import 'package:flutter_graphql_crud/services/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

getAllUsers() async {
  HttpLink link = HttpLink(GRAPHQL_ENDPOINT);
  GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );

  QueryResult queryResult = await client.query(
    QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(GET_ALL_USER),
    ),
  );
  // print("queryResult: ${queryResult.data?['users']}");

  return queryResult.data?['users'] ?? [];
}
