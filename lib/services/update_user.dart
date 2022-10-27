import 'package:flutter_graphql_crud/graphql/mutation.dart';
import 'package:flutter_graphql_crud/services/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

updateUser(var data, String? id) async {
  HttpLink link = HttpLink(GRAPHQL_ENDPOINT);
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );

  QueryResult queryResult = await qlClient.mutate(
    MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(UPDATE_USER),
      variables: {
        'data': data,
        'where': {
          'id': id
        }
      }
    ),
  );
  print("queryResult ==>> ${queryResult.data?['updateUser']}");
  return queryResult.data?['updateUser'];
}
