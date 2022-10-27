import 'package:flutter_graphql_crud/graphql/mutation.dart';
import 'package:flutter_graphql_crud/services/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

createUser(var data) async {
  debugPrint("come here der");
  debugPrint("data ===>> $data");
  HttpLink link = HttpLink(GRAPHQL_ENDPOINT);
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache( 
      store: HiveStore(),
    ),
  );

  QueryResult queryResult = await qlClient.mutate(
    MutationOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(CREATE_USER),
      variables: {
        'data': data
      }
    ),
  );
  debugPrint("queryResult ==>> ${queryResult.data?['createUser']}");

  return queryResult.data?['createUser'];
}
