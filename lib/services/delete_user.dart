import 'package:flutter_graphql_crud/graphql/mutation.dart';
import 'package:flutter_graphql_crud/services/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

deleteUser( String? id) async {
  HttpLink link = HttpLink(GRAPHQL_ENDPOINT);
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );

  QueryResult queryResult = await qlClient.mutate(
    MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(DELETE_USER),
      variables: {
        'where': {
          'id': id
        }
      }
    ),
  );
  print("queryResult ==>> ${queryResult.data?['deleteUser']}");
  return queryResult.data?['deleteUser'];
}