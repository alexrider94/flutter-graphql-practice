import 'package:flutter/material.dart';
import 'package:test_flutter/service/AuthService.dart';

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void dispose() {
    print("dispose() of LoginPage");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'LOGIN SCREEN',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "UserId"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Login'),
                onPressed: () async {
                  await AuthService.setTokenByLogin(
                          nameController.text, passwordController.text)
                      .then((value) {
                    bool result = AuthService.login();
                    if (result) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => UserListPage()),
                      // );
                      nameController.clear();
                      passwordController.clear();
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
