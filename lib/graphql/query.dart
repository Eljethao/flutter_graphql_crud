const String GET_ALL_USER = """
  query Users {
  users {
    total
    data {
      id
      firstName
      lastName
      birthday
      gender
      createdAt
    }
  }
}
""";
