import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zawtika/data_model/api_response.dart';
import 'package:zawtika/repository/prouduct_repository.dart';
import 'package:zawtika/screen/prodcut_detail.dart';

import '../app_config/my_theme.dart';
import '../custom/toast_message.dart';
import '../data_model/prodcut_model.dart';
import '../data_model/user_model.dart';
import '../repository/auth_repository.dart';
import 'widget/drawer_screen.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _productItem = [];
  bool _loading = true;

  // get all product item
  Future<void> getAllProductItem() async {
    ApiResponse response = await getProduct();
    final String token = await AuthRepository.getToken();
    if (response.error == null && token.isNotEmpty) {
      setState(() {
        // _productList = response.data as List<dynamic>;
        _productItem = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      toastMessage('${response.error}', Colors.white, Colors.grey[600]!);
    }
  }

  @override
  void initState() {
    getAllProductItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<DrawerControllerState> _drawerKey =
        GlobalKey<DrawerControllerState>();
    // final TextEditingController _searchController = TextEditingController();

    final CarouselController _carouselController = CarouselController();

    final List<String> imageList = [
      'assets/images/slider.jpg',
      'assets/images/slider1.jpg',
      'assets/images/slider2.jpg',
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Zawtika'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the Drawer when the menu icon is tapped
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                  )),
            ),
          )
        ],
      ),
      drawer: Drawer(
        key: _drawerKey,
        child: const MyDrawer(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: CarouselSlider(
              items: imageList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 2.5,
                initialPage: 0,
                scrollDirection: Axis.horizontal,
                autoPlayInterval: const Duration(seconds: 8),
                onPageChanged: (index, reason) {},
              ),
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.only(
          //     left: 20,
          //     right: 20,
          //     bottom: 20,
          //   ),
          //   color: MyTheme.splash_screen_color,
          //   child: SizedBox(
          //     height: 55,
          //     child: TextField(
          //       style: const TextStyle(
          //         fontSize: 14,
          //       ),
          //       controller: _searchController,
          //       onChanged: (value) {},
          //       decoration: InputDecoration(
          //         filled: true,
          //         fillColor: Colors.white,
          //         hintText: 'Search...',
          //         suffixIcon: IconButton(
          //           icon: Icon(
          //             Icons.clear,
          //             color: MyTheme.blue_grey,
          //           ),
          //           onPressed: () {
          //             _searchController.clear();
          //           },
          //         ),
          //         prefixIcon: IconButton(
          //           icon: Icon(
          //             Icons.search,
          //             color: MyTheme.accent_color,
          //           ),
          //           onPressed: () {
          //             // Perform the search here
          //           },
          //         ),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(20.0),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(20.0),
          //           borderSide: BorderSide(
          //             width: 1,
          //             color: MyTheme.blue_grey,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Container(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 5,
                  ),
                  child: Icon(
                    FontAwesomeIcons.coins,
                    color: Colors.amber[800],
                    size: 18,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text(
                    'Product Items',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: MyTheme.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: 3 / 3.2,
              ),
              itemCount: _productItem.length,
              itemBuilder: (context, index) {
                Product product = _productItem[index];
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.indigo.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(
                              product: product,
                            ),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        product.image!.isNotEmpty
                            ? Container(
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: product.image![0].url ?? '',
                                  fit: BoxFit.fitWidth,
                                  fadeInDuration: const Duration(seconds: 5),
                                  maxHeightDiskCache: 1000,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return ColoredBox(
                                      color: Colors.black12,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            value: progress.progress),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const ColoredBox(
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.error_outline,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            product.productName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.award,
                              size: 15,
                              color: MyTheme.accent_color,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              product.price!,
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              " Ks",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
