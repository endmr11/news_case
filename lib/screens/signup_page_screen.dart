import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/data/auth.dart';
import 'package:news_case/data/database.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/helpers/login_user.data.dart';
import 'package:news_case/style/style_helper.dart';

class SignUpPageScreen extends StatefulWidget {
  const SignUpPageScreen({Key? key}) : super(key: key);

  @override
  _SignUpPageScreenState createState() => _SignUpPageScreenState();
}

class _SignUpPageScreenState extends State<SignUpPageScreen> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  LoginUserData loginUserData = LoginUserData();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameController.text,
        "email": emailController.text,
      };
      loginUserData.setLoginUserNameAndMail(
          userNameController.text, emailController.text);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameController.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) async {
        Navigator.pushReplacementNamed(context, '/homePageScreen');
        databaseMethods.uploadUserInfo(userInfoMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("signup_app_title"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                            return val!.isEmpty || val.length < 3
                                ? "3 Karakterden Fazla Giriniz"
                                : null;
                          },
                          controller: userNameController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                            hintText: "Kullanıcı Adı",
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
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val.toString())
                                ? null
                                : "Geçerli Mail Giriniz";
                          },
                          controller: emailController,
                          style: simpleTextStyle(),
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
                            return val!.length < 6
                                ? "6 Karakterden Fazla Giriniz"
                                : null;
                          },
                          controller: passwordController,
                          style: simpleTextStyle(),
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
                      signMeUp();
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
                        "signup_button_text",
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
                      Text(
                        "Hesabın var mı? ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/signinPageScreen");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: LocaleText(
                            "signin_app_title",
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
