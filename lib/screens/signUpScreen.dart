/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../const/colors.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNoTextController = TextEditingController();

  String _selectedRole;

  List<String> _roles = [
    'Pelanggan',
    'Usahawan'
    // 'UsahawanUKM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Helper.getScreenHeight(context) * 1.0,
        decoration: ShapeDecoration(
          color: AppColor.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.width * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                width: 130, // Specify the desired width
                height: 130, // Specify the desired height
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: Image.asset("assets/images/virtual/mainlogo.png"),
                ),
              ),
              const Text(
                "Sila isi maklumat di bawah :",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              reusableTextField("Sila masukkan nama pengguna",
                  Icons.person_outline, false, _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan e-mel", Icons.person_outline,
                  false, _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan alamat", Icons.person_outline,
                  false, _addressTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan nombor telefon",
                  Icons.person_outline, false, _phoneNoTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan kata laluan", Icons.lock_outline,
                  true, _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih peranan pengguna',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                value: _selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              SignInSignUpButton(context, false, () {
                try {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Map<String, dynamic> data = {
                      "Username": _userNameTextController.text,
                      "Email": _emailTextController.text,
                      "Alamat": _addressTextController.text,
                      "PhoneNo": _phoneNoTextController.text,
                      "Password": _passwordTextController.text,
                      "Role": _selectedRole,
                    };

                    //usahawan dan pelanggan
                    FirebaseFirestore.instance
                        .collection("PelangganUsahawan")
                        .add(data);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                    print("Created New Account");
                  });
                } catch (e) {
                  String error = e.toString();
                  String errorMessage = 'An error occurred. Please try again.';
                  if (error.contains('email-already-in-use')) {
                    errorMessage = 'Email already in use';
                  } else if (error.contains('invalid-email')) {
                    errorMessage = 'Email is not valid';
                  } else if (error.contains('operation-not-allowed')) {
                    errorMessage =
                        'Email is not available. Please contact our Customer Service.';
                  } else if (error.contains('weak-password')) {
                    errorMessage = 'Password is not strong enough';
                  }
                  print(errorMessage);
                }
              }),
              const Text(
                "Sudah mempunyai akaun?",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => LoginScreen())));
                },
                child: const Text(
                  "Log Masuk >>",
                  style: TextStyle(
                      color: Color.fromARGB(255, 14, 55, 88),
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const/colors.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNoTextController = TextEditingController();

  late String _selectedRole;

  List<String> _roles = [
    'Pelanggan',
    'Usahawan'
    // 'UsahawanUKM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Helper.getScreenHeight(context) * 1.0,
        decoration: ShapeDecoration(
          color: AppColor.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.width * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                width: 130, // Specify the desired width
                height: 130, // Specify the desired height
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: Image.asset("assets/images/virtual/mainlogo.png"),
                ),
              ),
              const Text(
                "Sila isi maklumat di bawah :",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              reusableTextField("Sila masukkan nama pengguna",
                  Icons.person_outline, false, _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan e-mel", Icons.person_outline,
                  false, _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan alamat", Icons.person_outline,
                  false, _addressTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan nombor telefon",
                  Icons.person_outline, false, _phoneNoTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Sila masukkan kata laluan", Icons.lock_outline,
                  true, _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih peranan pengguna',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                value: _selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              SignInSignUpButton(context, false, () {
                if (_validateFields()) {
                  try {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Map<String, dynamic> data = {
                        "Username": _userNameTextController.text,
                        "Email": _emailTextController.text,
                        "Alamat": _addressTextController.text,
                        "PhoneNo": _phoneNoTextController.text,
                        "Password": _passwordTextController.text,
                        "Role": _selectedRole,
                      };

                      //usahawan dan pelanggan
                      FirebaseFirestore.instance
                          .collection("PelangganUsahawan")
                          .add(data);
                      Fluttertoast.showToast(
                        msg: 'Account created successfully!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                      print("Created New Account");
                    });
                  } catch (e) {
                    String error = e.toString();
                    String errorMessage =
                        'An error occurred. Please try again.';
                    if (error.contains('email-already-in-use')) {
                      errorMessage = 'Email already in use';
                    } else if (error.contains('invalid-email')) {
                      errorMessage = 'Email is not valid';
                    } else if (error.contains('operation-not-allowed')) {
                      errorMessage =
                          'Email is not available. Please contact our Customer Service.';
                    } else if (error.contains('weak-password')) {
                      errorMessage = 'Password is not strong enough';
                    }
                    print(errorMessage);
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: 'Error, please fill in all information correctly',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              }),
              const Text(
                "Sudah mempunyai akaun?",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => LoginScreen())),
                  );
                },
                child: const Text(
                  "Log Masuk >>",
                  style: TextStyle(
                      color: Color.fromARGB(255, 14, 55, 88),
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_userNameTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _addressTextController.text.isEmpty ||
        _phoneNoTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _selectedRole == null) {
      return false;
    }
    return true;
  }
}
