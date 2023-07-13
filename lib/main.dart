import 'package:flutter/material.dart';
import 'package:monkey_app_demo/categories/foodShop.dart';
import 'package:monkey_app_demo/categories/foodTest.dart';
import 'package:monkey_app_demo/screenPelanggan/displayIklanPelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedai.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiGajet.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKesihatan.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKosmetik.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiPakaian.dart';
import 'package:monkey_app_demo/screenPelanggan/displayProfilePelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/historyPesanan.dart';
import 'package:monkey_app_demo/screenPelanggan/kaedahGunaPelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiGajet.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiKesihatan.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiKosmetik.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiMakanan.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiPakaian.dart';
import 'package:monkey_app_demo/screenUsahawan/addGajet.dart';
import 'package:monkey_app_demo/screenUsahawan/addIklan.dart';
import 'package:monkey_app_demo/screenUsahawan/addKesihatan.dart';
import 'package:monkey_app_demo/screenUsahawan/addKosmetik.dart';
import 'package:monkey_app_demo/screenUsahawan/addMakanan.dart';
import 'package:monkey_app_demo/screenUsahawan/addPakaian.dart';
import 'package:monkey_app_demo/screenUsahawan/categoryUsahawan.dart';
import 'package:monkey_app_demo/screenUsahawan/displayGajet.dart';
import 'package:monkey_app_demo/screenUsahawan/displayIklan.dart';
import 'package:monkey_app_demo/screenUsahawan/displayKesihatan.dart';
import 'package:monkey_app_demo/screenUsahawan/displayKosmetik.dart';
import 'package:monkey_app_demo/screenUsahawan/displayMakanan.dart';
import 'package:monkey_app_demo/screenUsahawan/displayPakaian.dart';
import 'package:monkey_app_demo/screenUsahawan/homeScreenUsahawan.dart';
import 'package:monkey_app_demo/screenUsahawan/kaedahGuna.dart';
import 'package:monkey_app_demo/screenUsahawan/pesanan.dart';

import 'package:monkey_app_demo/screenUsahawan/usahawanKomenIklan.dart';
import 'package:monkey_app_demo/screens/displayProfile.dart';
import 'package:monkey_app_demo/screens/iklanPelanggan.dart';
import 'package:monkey_app_demo/screens/iklanUsahawan.dart';

import 'package:monkey_app_demo/screens/changeAddressScreen.dart';

import 'package:monkey_app_demo/screens/uploadIklan.dart';
import 'package:monkey_app_demo/screens/userScreen.dart';

import './screens/spashScreen.dart';
import './screens/landingScreen.dart';
import './screens/loginScreen.dart';
import './screens/signUpScreen.dart';

import './screens/newPwScreen.dart';
import './screens/introScreen.dart';
import './screens/homeScreen.dart';

import './screens/moreScreen.dart';

import './screens/profileScreen.dart';

import './screens/individualItem.dart';
import './screens/paymentScreen.dart';
import './screens/notificationScreen.dart';
import './screens/aboutScreen.dart';
import './screens/inboxScreen.dart';
import './screens/myOrderScreen.dart';
import './screens/checkoutScreen.dart';
import './const/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './screens/displayProduct.dart';
import 'screenPelanggan/aboutScreenPelanggan.dart';

import 'screenPelanggan/homePelanggan.dart';
import 'screenPelanggan/menuScreenPelanggan.dart';
import 'screenPelanggan/moreScreenPelanggan.dart';
import 'screens/displayImage.dart';
import 'screens/searchProduct.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        primarySwatch: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
            shape: MaterialStateProperty.all(
              StadiumBorder(),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
          ),
        ),
        textTheme: TextTheme(
          headline3: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headline5: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          headline6: TextStyle(
            color: AppColor.primary,
            fontSize: 25,
          ),
          bodyText2: TextStyle(
            color: AppColor.secondary,
          ),
        ),
      ),
      home: LandingScreen(),
      routes: {
        LandingScreen.routeName: (context) => LandingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),

        NewPwScreen.routeName: (context) => NewPwScreen(),
        IntroScreen.routeName: (context) => IntroScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),

        ProfileScreen.routeName: (context) => ProfileScreen(),
        MoreScreen.routeName: (context) => MoreScreen(),

        IndividualItem.routeName: (context) => IndividualItem(),
        PaymentScreen.routeName: (context) => PaymentScreen(),
        NotificationScreen.routeName: (context) => NotificationScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        InboxScreen.routeName: (context) => InboxScreen(),
        MyOrderScreen.routeName: (context) => MyOrderScreen(),
        CheckoutScreen.routeName: (context) => CheckoutScreen(),
        ChangeAddressScreen.routeName: (context) => ChangeAddressScreen(),

        //DisplayProduct.routeName: (context) => DisplayProduct(),
        IklanUsahawan.routeName: (context) => IklanUsahawan(),

        //FoodShop.routeName: (context) => FoodShop(),
        UploadIklan.routeName: (context) => UploadIklan(),
        IklanPelanggan.routeName: (context) => IklanPelanggan(),
        DisplayProfile.routeName: (context) => DisplayProfile(),
        DisplayImage.routeName: (context) => UploadImagePage(),
        Search.routeName: (context) => Search(),
        //FoodTest.routeName: (context) => FoodTest(),

        //Usahawan screens
        HomeScreenUsahawan.routeName: (context) => HomeScreenUsahawan(),
        CategoryUsahawan.routeName: (context) => CategoryUsahawan(),
        AddMakanan.routeName: (context) => AddMakanan(),
        DisplayMakanan.routeName: (context) => DisplayMakanan(),
        AddKesihatan.routeName: (context) => AddKesihatan(),
        DisplayKesihatan.routeName: (context) => DisplayKesihatan(),
        AddPakaian.routeName: (context) => AddPakaian(),
        DisplayPakaian.routeName: (context) => DisplayPakaian(),
        AddKosmetik.routeName: (context) => AddKosmetik(),
        DisplayKosmetik.routeName: (context) => DisplayKosmetik(),
        AddGajet.routeName: (context) => AddGajet(),
        DisplayGajet.routeName: (context) => DisplayGajet(),
        AddIklan.routeName: (context) => AddIklan(),
        DisplayIklan.routeName: (context) => DisplayIklan(),
        KedaiMakanan.routeName: (context) => KedaiMakanan(
              userEmail: '',
            ),
        KedaiKesihatan.routeName: (context) => KedaiKesihatan(
              userEmail: '',
            ),
        KedaiPakaian.routeName: (context) => KedaiPakaian(
              userEmail: '',
            ),
        KedaiKosmetik.routeName: (context) => KedaiKosmetik(
              userEmail: '',
            ),
        KedaiGajet.routeName: (context) => KedaiGajet(),
        Pesanan.routeName: (context) => Pesanan(),
        UsahawanKomenIklan.routeName: (context) => UsahawanKomenIklan(),
        KaedahGuna.routeName: (context) => KaedahGuna(),

        //Pelanggan screens

        HomePelanggan.routeName: (context) => HomePelanggan(),
        DisplayProfilePelanggan.routeName: (context) =>
            DisplayProfilePelanggan(),
        MoreScreenPelanggan.routeName: (context) => MoreScreenPelanggan(),
        AboutScreenPelanggan.routeName: (context) => AboutScreenPelanggan(),
        MenuScreenPelanggan.routeName: (context) => MenuScreenPelanggan(),
        DisplayKedai.routeName: (context) => DisplayKedai(),
        DisplayKedaiKesihatan.routeName: (context) => DisplayKedaiKesihatan(),
        DisplayKedaiPakaian.routeName: (context) => DisplayKedaiPakaian(),
        DisplayKedaiKosmetik.routeName: (context) => DisplayKedaiKosmetik(),
        DisplayKedaiGajet.routeName: (context) => DisplayKedaiGajet(),
        DisplayIklanPelanggan.routeName: (context) => DisplayIklanPelanggan(),
        HistoryPesanan.routeName: (context) => HistoryPesanan(),
        KaedahGunaPelanggan.routeName: (context) => KaedahGunaPelanggan(),
      },
    );
  }
}
