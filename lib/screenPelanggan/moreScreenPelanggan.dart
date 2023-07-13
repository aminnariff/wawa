//info
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screenPelanggan/aboutScreenPelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/historyPesanan.dart';
import 'package:monkey_app_demo/screenPelanggan/homePelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/kaedahGunaPelanggan.dart';
import 'package:monkey_app_demo/screens/landingScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'navBarPelanggan.dart';

class MoreScreenPelanggan extends StatelessWidget {
  static const routeName = "/moreScreenPelanggan";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tetapan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePelanggan(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Log keluar'),
                    content: Text('Anda yakin ingin log keluar?'),
                    actions: [
                      TextButton(
                        child: Text('Batal'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Log Keluar'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LandingScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Pos2Pos2UKM",
                        style: Helper.getTheme(context).headline5,
                      ),
                      // Image.asset(
                      //   Helper.getAssetName("cart.png", "virtual"),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MoreCard(
                    image: Image.asset(
                      Helper.getAssetName("shopping_bag.png", "virtual"),
                    ),
                    name: "Senarai Pesanan",
                    handler: () {
                      Navigator.of(context).pushNamed(HistoryPesanan.routeName);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MoreCard(
                    image: Image.asset(
                      Helper.getAssetName("info.png", "virtual"),
                    ),
                    name: "Info Aplikasi",
                    handler: () {
                      Navigator.of(context).pushNamed(AboutScreenPelanggan.routeName);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MoreCard(
                    image: Image.asset(
                      Helper.getAssetName("info.png", "virtual"),
                    ),
                    name: "Panduan Penggunaan Aplikasi",
                    handler: () {
                      Navigator.of(context).pushNamed(KaedahGunaPelanggan.routeName);
                    },
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBarPelanggan(
              more: true,
            ),
          )
        ],
      ),
    );
  }
}

class MoreCard extends StatelessWidget {
  const MoreCard({
    Key? key,
    required String name,
    required Image image,
    bool isNoti = false,
    required Function()? handler,
  })  : _name = name,
        _image = image,
        _isNoti = isNoti,
        _handler = handler,
        super(key: key);

  final String _name;
  final Image _image;
  final bool _isNoti;
  final Function()? _handler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handler,
      child: Container(
        height: 70,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: AppColor.placeholderBg,
              ),
              child: Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColor.placeholder,
                      ),
                      child: _image),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _name,
                    style: TextStyle(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 30,
                width: 30,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: AppColor.placeholderBg,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.secondary,
                  size: 17,
                ),
              ),
            ),
            if (_isNoti)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.only(
                    right: 50,
                  ),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "15",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
