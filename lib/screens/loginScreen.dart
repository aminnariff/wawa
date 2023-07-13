import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/homePelanggan.dart';
import 'package:monkey_app_demo/screenUsahawan/homeScreenUsahawan.dart';
import '../const/colors.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../screens/signUpScreen.dart';
import '../utils/helper.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  static const routeName = "/loginScreen";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //auto
    // if (kDebugMode) {
    //   _passwordTextController.text = 'wawa123';
    //   _emailTextController.text = 'wawa123@gmail.com';
    // }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Helper.getScreenHeight(context) * 1,
        decoration: ShapeDecoration(
          color: AppColor.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/virtual/mainlogo.png"),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Masukkan e-mel", Icons.person_outline, false, _emailTextController),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Masukkan kata laluan", Icons.lock_outline, true, _passwordTextController),
              SizedBox(
                height: 20,
              ),
              SignInSignUpButton(context, true, () async {
                try {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text, password: _passwordTextController.text)
                      .then((value) async {
                    String? uid = value.user?.uid;
                    String? email = value.user?.email;
                    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                        .collection('PelangganUsahawan')
                        .where('Email', isEqualTo: email)
                        .get();
                    if (userSnapshot.docs.isNotEmpty) {
                      String role = userSnapshot.docs[0].get('Role');
                      if (role == 'Usahawan') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreenUsahawan()),
                        );
                      } else if (role == 'Pelanggan') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePelanggan()),
                        );
                      } else if (role == 'UsahawanUKM') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePelanggan()),
                        );
                      } else {
                        print('Invalid role: $role');
                      }
                    } else {
                      print('User not found');
                    }
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Ralat'),
                          content: Text('E-mel atau kata laluan tidak sah.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                } catch (e) {
                  String error = e.toString();
                  String errorMessage = 'An error occurred. Please try again.';
                  if (error.contains('invalid-email')) {
                    errorMessage = 'Email is not valid';
                  } else if (error.contains('operation-not-allowed')) {
                    errorMessage = 'Email is not available. Please contact our Customer Service.';
                  } else if (error.contains('weak-password')) {
                    errorMessage = 'Password is not strong enough';
                  }
                  print(errorMessage);
                }
              }),

              // const Text(
              //   "or Login With",
              //   style: TextStyle(color: Colors.black),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 50,
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(
              //         Color(
              //           0xFF367FC0,
              //         ),
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           Helper.getAssetName(
              //             "fb.png",
              //             "virtual",
              //           ),
              //         ),
              //         SizedBox(
              //           width: 20,
              //         ),
              //         Text("Login with Facebook"),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 50,
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(
              //           Color.fromARGB(255, 200, 32, 14)),
              //     ),
              //     onPressed: () {},
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           Helper.getAssetName(
              //             "google.png",
              //             "virtual",
              //           ),
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text("Login with Google")
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Pendaftaran baru?",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => SignUpScreen())));
                },
                child: const Text(
                  "Klik disini >>",
                  style: TextStyle(color: Color.fromARGB(255, 14, 55, 88), fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //signUpOption()
            ]),
          ),
        ),
      ),
    );
  }

  /*Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(context,
            //  MaterialPageRoute(builder: ((context) => SignUpScreen())));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }*/
}
