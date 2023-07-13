import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/displayIklanPelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/displayProfilePelanggan.dart';
import '../const/colors.dart';
import '../utils/helper.dart';
import 'homePelanggan.dart';
import 'menuScreenPelanggan.dart';
import 'moreScreenPelanggan.dart';

class CustomNavBarPelanggan extends StatelessWidget {
  final bool home;
  final bool menu;
  final bool offer;
  final bool profile;
  final bool more;

  const CustomNavBarPelanggan(
      {Key? key, this.home = false, this.menu = false, this.offer = false, this.profile = false, this.more = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: Helper.getScreenWidth(context),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: Helper.getScreenWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!menu) {
                        //kategori
                        Navigator.of(context).pushReplacementNamed(MenuScreenPelanggan.routeName); //choose category
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menu
                            ? Image.asset(
                                Helper.getAssetName("more_filled.png", "virtual"),
                              )
                            : Image.asset(
                                Helper.getAssetName("more.png", "virtual"),
                              ),
                        menu ? Text("Kedai", style: TextStyle(color: AppColor.orange)) : Text("Kedai"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!offer) {
                        Navigator.of(context).pushReplacementNamed(DisplayIklanPelanggan.routeName);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        offer
                            ? Image.asset(
                                Helper.getAssetName("bag_filled.png", "virtual"),
                              )
                            : Image.asset(
                                Helper.getAssetName("bag.png", "virtual"),
                              ),
                        offer ? Text("Iklan", style: TextStyle(color: AppColor.orange)) : Text("Iklan"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!profile) {
                        Navigator.of(context).pushReplacementNamed(DisplayProfilePelanggan.routeName);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profile
                            ? Image.asset(
                                Helper.getAssetName("user_filled.png", "virtual"),
                              )
                            : Image.asset(
                                Helper.getAssetName("user.png", "virtual"),
                              ),
                        profile ? Text("Profil", style: TextStyle(color: AppColor.orange)) : Text("Profil"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!more) {
                        Navigator.of(context).pushReplacementNamed(MoreScreenPelanggan.routeName);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        more
                            ? Image.asset(
                                Helper.getAssetName("menu_filled.png", "virtual"),
                              )
                            : Image.asset(
                                Helper.getAssetName("menu.png", "virtual"),
                              ),
                        more ? Text("Tetapan", style: TextStyle(color: AppColor.orange)) : Text("Tetapan"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: home ? AppColor.orange : AppColor.placeholder,
                onPressed: () {
                  if (!home) {
                    Navigator.of(context).pushReplacementNamed(HomePelanggan.routeName);
                  }
                },
                child: Image.asset(Helper.getAssetName("home_white.png", "virtual")),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width * 0.375,
      0,
      size.width * 0.375,
      size.height * 0.1,
    );
    path.cubicTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.9,
      size.width * 0.625,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.625,
      0,
      size.width * 0.7,
      0.1,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
