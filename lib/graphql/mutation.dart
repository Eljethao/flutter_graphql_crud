const String CREATE_USER = """ 
  mutation Mutation(\$data: UserInput!) {
  createUser(data: \$data) {
    id
  }
}
""";

const String UPDATE_USER = """
  mutation Mutation(\$data: UserInput!, \$where: UserWhereInputOne!) {
  updateUser(data: \$data, where: \$where) {
    id
  }
}
""";

const String DELETE_USER = """
  mutation DeleteUser(\$where: UserWhereInputOne!) {
  deleteUser(where: \$where) {
    id
  }
}
""";
