import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedai.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiGajet.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKesihatan.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKosmetik.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiPakaian.dart';
import 'package:monkey_app_demo/screenPelanggan/historyPesanan.dart';
import 'package:monkey_app_demo/screenPelanggan/menuScreenPelanggan.dart';
import 'package:monkey_app_demo/screenPelanggan/navBarPelanggan.dart';
import '../const/colors.dart';
import '../utils/helper.dart';
import '../screens/individualItem.dart';

class HomePelanggan extends StatefulWidget {
  static const routeName = "/HomePelanggan";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePelanggan> {
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('PelangganUsahawan')
        .where('Email', isEqualTo: user?.email)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        username = snapshot.docs.first.get('Username');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pos2Pos2UKM                               ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(HistoryPesanan.routeName);
              },
              child: Image.asset(
                Helper.getAssetName("shopping_bag.png", "virtual"),
                color: Colors.white, // Set the color of the shopping bag icon to orange
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selamat Datang,",
                          style: Helper.getTheme(context).headlineSmall,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context)
                        //         .pushNamed(HistoryPesanan.routeName);
                        //   },
                        //   child:
                        //   Image.asset(
                        //     Helper.getAssetName("shopping_bag.png", "virtual"),
                        //     color: AppColor
                        //         .orange, // Set the color of the shopping bag icon to orange
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Text(
                    "   $username !",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.orange, // Set the text color to orange
                      fontFamily: "Roboto",
                    ),
                  ),

                  // Divider(
                  //   color: AppColor.orange, // Set the color of the line
                  //   thickness: 1, // Set the thickness of the line
                  // ),
                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kategori",
                          style: Helper.getTheme(context).headlineSmall,
                        ),
                        // Image.asset(Helper.getAssetName("cart.png", "virtual"))
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   height: 20,
                  // ),
                  // SearchBar(
                  //   title: "Carian Produk",
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedai.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.orange, // Set the color of the border
                                  width: 2.0, // Set the width of the border
                                ),
                                borderRadius: BorderRadius.circular(8.0), // Set the border radius
                              ),
                              child: CategoryCard(
                                image: Image.asset(
                                  Helper.getAssetName("makanan.png", "real"),
                                  fit: BoxFit.cover,
                                ),
                                name: "Makanan",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedaiKesihatan.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.orange, // Choose the border color you desire
                                  width: 2.0, // Choose the border width you desire
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CategoryCard(
                                image: Image.asset(
                                  Helper.getAssetName("kesihatan.png", "real"),
                                  fit: BoxFit.cover,
                                ),
                                name: "Kesihatan",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedaiPakaian.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.orange, // Set the desired border color
                                  width: 2.0, // Set the desired border width
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CategoryCard(
                                image: Image.asset(
                                  Helper.getAssetName("pakaian.png", "real"),
                                  fit: BoxFit.cover,
                                ),
                                name: "Pakaian",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedaiKosmetik.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.orange, // Set the border color here
                                  width: 2.0, // Set the border width here
                                ),
                                borderRadius: BorderRadius.circular(8.0), // Set the border radius here
                              ),
                              child: CategoryCard(
                                image: Image.asset(
                                  Helper.getAssetName("kosmetik.png", "real"),
                                  fit: BoxFit.cover,
                                ),
                                name: "Kosmetik",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedaiGajet.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.orange, // Specify the border color here
                                  width: 2.0, // Specify the border width here
                                ),
                                borderRadius: BorderRadius.circular(10.0), // Specify the border radius here
                              ),
                              child: CategoryCard(
                                image: Image.asset(
                                  Helper.getAssetName("gajet.png", "real"),
                                  fit: BoxFit.cover,
                                ),
                                name: "Gajet Elektronik",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kedai Popular",
                          style: Helper.getTheme(context).headlineSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MenuScreenPelanggan(),
                              ),
                            );
                          },
                          child: Text("Lihat >>"),
                        ),
                      ],
                    ),
                  ),
                  // Image.network(
                  //   'https://firebasestorage.googleapis.com/v0/b/pos2pos2ukmfirebase.appspot.com/o/product%2FABCDEFGHIJKL_0?alt=media&token=9952739b-c924-4a88-bb32-3588e9fdeb93',
                  //   // Optional: You can set additional properties for the image
                  //   fit: BoxFit
                  //       .contain, // Adjust the image's fit within the container
                  //   width: 200, // Set the desired width of the image
                  //   height: 200, // Set the desired height of the image
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  RestaurantCard(
                    image: Image.asset(
                      Helper.getAssetName("maggi.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Maggi Kari Nestle",
                  ),
                  RestaurantCard(
                    image: Image.asset(
                      Helper.getAssetName("baju.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Bundle Fauzi.co",
                  ),
                  RestaurantCard(
                    image: Image.asset(
                      Helper.getAssetName("headphone.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Gizi Shop",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kedai Cadangan",
                          style: Helper.getTheme(context).headlineSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MenuScreenPelanggan(),
                              ),
                            );
                          },
                          child: Text("Lihat >>"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MostPopularCard(
                            image: Image.asset(
                              Helper.getAssetName("ramen.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Ramenyeon Shop",
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          MostPopularCard(
                            name: "Shaklee Beauty.co",
                            image: Image.asset(
                              Helper.getAssetName("shaklee.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Produk Popular",
                          style: Helper.getTheme(context).headlineSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MenuScreenPelanggan(),
                              ),
                            );
                          },
                          child: Text("Lihat >>"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(IndividualItem.routeName);
                          },
                          child: RecentItemCard(
                            image: Image.asset(
                              Helper.getAssetName("milo.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Milo 3in1",
                          ),
                        ),
                        RecentItemCard(
                            image: Image.asset(
                              Helper.getAssetName("axisy.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Axis-Y Dark Spot Serum"),
                        RecentItemCard(
                            image: Image.asset(
                              Helper.getAssetName("munchy.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Munchy Biscuits"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: CustomNavBarPelanggan(
                home: true,
              )),
        ],
      ),
    );
  }
}

class RecentItemCard extends StatelessWidget {
  const RecentItemCard({
    Key? key,
    required String name,
    required Image image,
  })  : _name = name,
        _image = image,
        super(key: key);

  final String _name;
  final Image _image;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 80,
            height: 80,
            child: _image,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: Helper.getTheme(context).headlineMedium?.copyWith(color: AppColor.primary),
                ),
                Row(
                  children: [
                    Text("Kedai"),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        ".",
                        style: TextStyle(
                          color: AppColor.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Usahawan UKM"),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      Helper.getAssetName("star_filled.png", "virtual"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(
                        color: AppColor.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Beli sekarang !')
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MostPopularCard extends StatelessWidget {
  const MostPopularCard({
    Key? key,
    required String name,
    required Image image,
  })  : _name = name,
        _image = image,
        super(key: key);

  final String _name;
  final Image _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 300,
            height: 200,
            child: _image,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _name,
          style: Helper.getTheme(context).headlineMedium?.copyWith(color: AppColor.primary),
        ),
        Row(
          children: [
            Text("Kedai"),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                ".",
                style: TextStyle(
                  color: AppColor.orange,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text("Promosi Hebat !!!"),
            SizedBox(
              width: 20,
            ),
            Image.asset(
              Helper.getAssetName("star_filled.png", "virtual"),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "4.9",
              style: TextStyle(
                color: AppColor.orange,
              ),
            )
          ],
        )
      ],
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    Key? key,
    required String name,
    required Image image,
  })  : _image = image,
        _name = name,
        super(key: key);

  final String _name;
  final Image _image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 200, width: double.infinity, child: _image),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      _name,
                      style: Helper.getTheme(context).displaySmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      Helper.getAssetName("star_filled.png", "virtual"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(
                        color: AppColor.orange,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(""),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Kedai"),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        ".",
                        style: TextStyle(
                          color: AppColor.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Dijual oleh usahawan UKM"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required Image image,
    required String name,
  })  : _image = image,
        _name = name,
        super(key: key);

  final String _name;
  final Image _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            height: 100,
            child: _image,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          _name,
          style: Helper.getTheme(context).headlineMedium?.copyWith(color: AppColor.primary, fontSize: 16),
        ),
      ],
    );
  }
}
