class QueryMutation {
  String getUser() {
    return """ 
      query{
        getUsers{
          no
          userId
          userName
          createdDate
          modifiedDate
          password
        }
      }
    """;
  }

  static String login = """
    mutation{
      login(\$id:String!, \$password:String!){
        user{
          userId
        }
        token
      }
    }
  """;

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
}
