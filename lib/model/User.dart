class User {
  User(this.no, this.userId, this.userName, this.createdDate, this.modifiedDate,
      this.password);

  final int no;
  final String userId;
  final String userName;
  final String createdDate;
  final String modifiedDate;
  final String password;

  getNo() => this.no;
  getUserId() => this.userId;
  getUserName() => this.userName;
  getCreatedDate() => this.createdDate;
  getModifiedDate() => this.modifiedDate;
  getPassword() => this.password;
}
