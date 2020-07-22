class QueryMutation {
  static String fetchUser = """ 
    query{ 
      getUsers{
        no
        userId
        userName
        createdDate
        modifiedDate
        password
        corpId{
          corpId
          corpName
          corpContactNumber
        }
      }
    }
  """;

  static String loginUser(String userId, String password) {
    return """
    query{
      loginUser(
      userId: "$userId"
      password: "$password"
      ){
        token
        user{
          userId
        }
      }
    }
    """;
  }

  static String deleteUser(String userId) {
    return """
    mutation{
      deleteUser(
        userId: "$userId"
      ){
        resultCount
      }
    }
    """;
  }

  static String createUser(
      String userId, String userName, String corpId, String password) {
    return """
    mutation{
      createUser(
        userId: "$userId"
        userName: "$userName"
        corpId: "$corpId"
        password: "$password"
      ){
        resultCount
      }
    }
    """;
  }

  static String updateUser(
      int no, String userId, String userName, String corpId, String password) {
    return """
    mutation{
      createUser(
        no: "$no"
        userId: "$userId"
        userName: "$userName"
        corpId: "$corpId"
        password: "$password"
      ){
        resultCount
      }
    }
    """;
  }
}
