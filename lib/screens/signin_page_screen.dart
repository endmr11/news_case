import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/data/auth.dart';
import 'package:news_case/data/database.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/helpers/login_user.data.dart';

class SignInPageScreen extends StatefulWidget {
  const SignInPageScreen({Key? key}) : super(key: key);

  @override
  _SignInPageScreenState createState() => _SignInPageScreenState();
}

class _SignInPageScreenState extends State<SignInPageScreen> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await databaseMethods.getUserInfo(emailController.text);

          LoginUserData().setLoginUserNameAndMail(
              userInfoSnapshot.docs[0]["name"], emailController.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserEmailSharedPreference(emailController.text);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0]["name"]);
          Navigator.pushReplacementNamed(context, '/homePageScreen');
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("signin_app_title"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/settingsPageScreen"),
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val.toString())
                          ? null
                          : "Geçerli Mail Adresi Girin";
                    },
                    controller: emailController,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val!.length < 6 ? "6 Karakterden fazla gir" : null;
                    },
                    controller: passwordController,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onTap: () {
                signIn();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const LocaleText(
                  "signin_button_text",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocaleText(
                  "signin_account_text",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, "/signupPageScreen");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: LocaleText(
                      "signup_app_title",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
