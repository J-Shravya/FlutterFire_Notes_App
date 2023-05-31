import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart'; // Import the package
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class Registerscreen extends StatefulWidget {
  Registerscreen({Key? key}) : super(key: key);

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 76, 81, 175),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              loading
                  ? CircularProgressIndicator()
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("All fields are required!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Passwords don't match!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            User? result = await AuthService().register(
                              emailController.text,
                              passwordController.text,
                              context,
                            );
                            if (result != null) {
                              print("Success");
                              // print(result.email);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homescreen(result)),
                                  (route) => false);
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                  );
                },
                child: Text("Already have an account? Login here"),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              loading
                  ? CircularProgressIndicator()
                  : SignInButton(
                      Buttons.Google,
                      text: "Continue with Google",
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await AuthService().signInWithGoogle();
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
