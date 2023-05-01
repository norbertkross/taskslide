import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskslide/UIs/home/body.dart';
import 'package:taskslide/UIs/login-and-onboarding/loginBackground.dart';
import 'package:taskslide/state/state.dart';

class LoginEmailPassword extends StatefulWidget {
  @override
  _LoginEmailPasswordState createState() => _LoginEmailPasswordState();
}

class _LoginEmailPasswordState extends State<LoginEmailPassword> {
  bool working = false;
  bool isLogin = true;

  bool loginHide = true;
  bool registerHide = true;

  bool isLoading = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

saveIdToDiskAndGoHome(String email) {
  taskState.setUserEmailasID(email, context);
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (builder) => Body()), (_) => false);
}

  Future<void> _handleSignIn() async {
    try {
     //await _googleSignIn.signIn();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      Map<String,dynamic> user = {
        "id": googleSignInAccount.id,
        "email": googleSignInAccount.email,
        "display_name": googleSignInAccount.displayName,
        "picture_url": googleSignInAccount.photoUrl,
        "last_signed_in":DateTime.now().toIso8601String(),
      };

      // Todo Hit a sign in endpoint

     saveIdToDiskAndGoHome(googleSignInAccount.email);
           print("Success: ${googleSignInAccount.email}");

    } catch (error) {
      print("ERROR: $error");
    }
  }

  TextEditingController loginUsernameController = TextEditingController();
  String get loginUserName => loginUsernameController.text;

  TextEditingController passwordController = TextEditingController();
  String get password => passwordController.text;

  TextEditingController usernameController = TextEditingController();
  String get userName => usernameController.text;

  TextEditingController emailController = TextEditingController();
  String get email => emailController.text;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final taskState = Get.put(TaskState());

  verifyIsLoggedIn() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String isAuthorized = await taskState.getuserID();
      if (isAuthorized.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => Body()), (_) => false);
      } else {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
            Positioned(
              // left: 0.0,
              // right: 0.0,
              // top: 0,
              child: Center(child: LoginBackround())),
          
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (__) {
              __.disallowIndicator();
              return false;
            },
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .50,
                ),
                // Center(
                //   child: Wrap(
                //     children: [
                //       MouseRegion(
                //         cursor: SystemMouseCursors.click,
                //         child: CupertinoButton(
                //             child: Text(
                //               "login",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w300,
                //                   fontSize: 22,
                //                   color: Theme.of(context).accentColor),
                //             ),
                //             onPressed: () {
                //               setState(() {
                //                 isLogin = true;
                //               });
                //             }),
                //       ),
                //       MouseRegion(
                //         cursor: SystemMouseCursors.click,
                //         child: CupertinoButton(
                //             child: Text(
                //               "Register",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w300,
                //                   fontSize: 22,
                //                   color: Theme.of(context).accentColor),
                //             ),
                //             onPressed: () {
                //               setState(() {
                //                 isLogin = false;
                //               });
                //             }),
                //       ),
                //     ],
                //   ),
                // ),
                // isLogin == true ? emailPassword() : registerEmailPassword(),
                loginbutton(),
                SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       // N().to(context, route: ForgotPassword());
                //     },
                //     child: Text(
                //       "Forgot Password?",
                //       style: TextStyle(color: Theme.of(context).accentColor),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     GestureDetector(
                //       onLongPressEnd: (_) {
                //         print("onLongPressUp");
                //         // N().to(context, route: LoginAdmin());
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.all(18.0),
                //         child: Icon(
                //           Icons.shield,
                //           color: Theme.of(context)
                //               .unselectedWidgetColor
                //               .withOpacity(.4),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
         Align(
          alignment: Alignment.bottomCenter,
           child: Padding(
             padding:  EdgeInsets.only(bottom:Platform.isAndroid?  40 :60.0),
             child: Text(
                          "Securely login to continue",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
           ),
         ), 
        ],
      ),
    );
  }

  Widget emailPassword() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 8.0, bottom: 8.0, left: 20.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            userInputText(
                                controllerType: ControllerType
                                    .loginUsernameController, // loginUsernameController,
                                hintText: "Email / username",
                                leading: Icon(Icons.email)),
                            userInputText(
                                controllerType: ControllerType
                                    .passwordController, //passwordController,
                                hintText: "Password",
                                leading: Icon(Icons.lock),
                                isPassword: true,
                                dint: 1),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget registerEmailPassword() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 8.0, bottom: 8.0, left: 20.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            userInputText(
                                controllerType: ControllerType
                                    .usernameController, // usernameController,
                                hintText: "Username",
                                leading: Icon(Icons.person)),
                            userInputText(
                                controllerType: ControllerType
                                    .emailController, // emailController,
                                hintText: "Email",
                                leading: Icon(Icons.email)),
                            userInputText(
                                controllerType: ControllerType
                                    .passwordController, // passwordController,
                                hintText: "Password",
                                leading: Icon(Icons.lock),
                                isPassword: true,
                                dint: 0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget loginbutton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: isLoading == true
                ? null
                : () {
                    _handleSignIn();
                    // validateAndSend();
                  },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      Image.asset("assets/google-logo-9808.png",height: 25,width: 25,),

                      Container(
                        color: Theme.of(context).cardColor,
                        height: 60,
                        child: Center(
                            child: isLoading == true
                                ? CupertinoActivityIndicator()
                                : Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        color: Theme.of(context).disabledColor.withOpacity(.3),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  TextEditingController updateText(ControllerType value, {String theUpdate}) {
    switch (value) {
      case ControllerType.loginUsernameController:
        setState(() {
          loginUsernameController.text = theUpdate;
        });
        return loginUsernameController;
        break;
      case ControllerType.passwordController:
        setState(() {
          passwordController.text = theUpdate;
        });
        return passwordController;
        break;
      case ControllerType.usernameController:
        setState(() {
          usernameController.text = theUpdate;
        });
        return usernameController;
        break;
      case ControllerType.emailController:
        setState(() {
          emailController.text = theUpdate;
        });
        return emailController;
        break;
      default:
        setState(() {
          loginUsernameController.text = theUpdate;
        });
        return loginUsernameController;
    }
  }

  Widget userInputText(
      {ControllerType controllerType,
      String hintText,
      Icon leading,
      bool isPassword,
      int dint}) {
    //  bool passwordLocal = true;
    return Container(
      child: TextField(
        controller: updateText(controllerType),
        onChanged: (_) {
         // updateText(controllerType, theUpdate: _);
        },
        obscureText: isPassword != null
            ? dint == 1
                ? loginHide
                : registerHide
            : false,
        decoration: InputDecoration(
            suffixIcon: isPassword == true
                ? IconButton(
                    icon: dint == 1
                        ? Icon(loginHide == true
                            ? Icons.visibility
                            : Icons.visibility_off)
                        : dint == 0
                            ? Icon(registerHide == true
                                ? Icons.visibility
                                : Icons.visibility_off)
                            : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        if (dint == 1) {
                          loginHide = !loginHide;
                        } else {
                          registerHide = !registerHide;
                        }
                      });
                    },
                  )
                : null,
            prefixIcon: leading,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }

  loginUser() {
    if (
      true
      // loginUsernameController.text.isNotEmpty &&
      //   emailController.text.isNotEmpty
        ) {
      taskState.setUserEmailasID("test@taskslide.com", context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => Body()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Username or Email Is Empty"),
      ));
    }
  }

  registerUser() {}

  validateAndSend() {
    if (isLogin) {
      // login user
      loginUser();
    } else {
      // register new user
      registerUser();
    }
  }
}

enum ControllerType {
  loginUsernameController,
  passwordController,
  usernameController,
  emailController
}
