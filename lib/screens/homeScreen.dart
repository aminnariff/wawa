import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedai.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKosmetik.dart';

import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import '../screens/individualItem.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selamat Datang!",
                          style: Helper.getTheme(context).headline5,
                        ),
                        // Image.asset(Helper.getAssetName("cart.png", "virtual"))
                      ],
                    ),
                  ),
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
                          style: Helper.getTheme(context).headline5,
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
                              // Navigator.of(context)
                              //   .pushNamed(AddProduct.routeName);
                            },
                            child: CategoryCard(
                              image: Image.asset(
                                Helper.getAssetName("hamburger2.jpg", "real"),
                                fit: BoxFit.cover,
                              ),
                              name: "Makanan",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedai.routeName);
                            },
                            child: CategoryCard(
                              image: Image.asset(
                                Helper.getAssetName("rice2.jpg", "real"),
                                fit: BoxFit.cover,
                              ),
                              name: "Kesihatan",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(DisplayKedaiKosmetik.routeName);
                            },
                            child: CategoryCard(
                              image: Image.asset(
                                Helper.getAssetName("fruit.jpg", "real"),
                                fit: BoxFit.cover,
                              ),
                              name: "Kosmetik",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context)
                              //     .pushNamed(FoodTest.routeName);
                            },
                            child: CategoryCard(
                              image: Image.asset(
                                Helper.getAssetName("rice.jpg", "real"),
                                fit: BoxFit.cover,
                              ),
                              name: "Pakaian",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kedai Popular",
                          style: Helper.getTheme(context).headline5,
                        ),
                        TextButton(onPressed: () {}, child: Text("View all"))
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
                      Helper.getAssetName("pizza2.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Minute by tuk tuk",
                  ),
                  RestaurantCard(
                    image: Image.asset(
                      Helper.getAssetName("breakfast.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Cafe de Noir",
                  ),
                  RestaurantCard(
                    image: Image.asset(
                      Helper.getAssetName("bakery.jpg", "real"),
                      fit: BoxFit.cover,
                    ),
                    name: "Bakes by Tella",
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Most Popular",
                          style: Helper.getTheme(context).headline5,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("View all"),
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
                              Helper.getAssetName("pizza4.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Cafe De Bambaa",
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          MostPopularCard(
                            name: "Burger by Bella",
                            image: Image.asset(
                              Helper.getAssetName("dessert3.jpg", "real"),
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
                          "Recent Items",
                          style: Helper.getTheme(context).headline5,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("View all"),
                        ),
                      ],
                    ),
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
                              Helper.getAssetName("pizza3.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Mulberry Pizza by Josh",
                          ),
                        ),
                        RecentItemCard(
                            image: Image.asset(
                              Helper.getAssetName("coffee.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Barita"),
                        RecentItemCard(
                            image: Image.asset(
                              Helper.getAssetName("pizza.jpg", "real"),
                              fit: BoxFit.cover,
                            ),
                            name: "Pizza Rush Hour"),
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
              child: CustomNavBar(
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
                  style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary),
                ),
                Row(
                  children: [
                    Text("Cafe"),
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
                    Text("Western Food"),
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
                    Text('(124) Ratings')
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
          style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary),
        ),
        Row(
          children: [
            Text("Cafe"),
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
            Text("Western Food"),
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
                      style: Helper.getTheme(context).headline3,
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
                    Text("(124 ratings)"),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Cafe"),
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
                    Text("Western Food"),
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
          style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary, fontSize: 16),
        ),
      ],
    );
  }
}
