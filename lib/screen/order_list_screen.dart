import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zawtika/app_config/my_theme.dart';
import 'package:zawtika/repository/order_repository.dart';

import '../data_model/api_response.dart';
import '../data_model/order_model.dart';
import '../repository/auth_repository.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  List<dynamic> _orderList = [];
  double totalPrice = 0;
  int totalKyat = 0;
  int totalPae = 0;
  int totalYway = 0;
  var formatter = NumberFormat('#,##,000');

  List<int> selectCategory = [];
  // List<String> categories = ['All Order', 'Complete', 'Pending'];
  Map<int, String> categoriesName = {0: 'Pending', 1: 'Complete'};

  // Get order list
  Future<void> getOrder() async {
    int userId = await AuthRepository.getUserId();
    ApiResponse response = await getOrderAll();
    final String token = await AuthRepository.getToken();

    if (response.error == null && token.isNotEmpty) {
      List orderList = response.data as List<dynamic>;
      // _orderList = response.data as List<dynamic>;
      _orderList =
          orderList.where((orderData) => orderData.userId == userId).toList();
      setState(() {
        _loading = _loading ? !_loading : _loading;
        if (_searchController.text.toString().isNotEmpty) {
          _orderList = _orderList
              .where((productData) => productData.products.productName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        } else {
          _orderList = response.data as List<dynamic>;
        }
      });
    } else {
      print('Error');
      // toastMessage('${response.error}', Colors.white, Colors.grey[600]!);
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var order in _orderList) {
      if (order.status == 1) {
        total += double.parse('${order.confirmPrice}');
      }
    }
    return total;
  }

  int calculateTotalKyat() {
    int total = 0;
    for (var order in _orderList) {
      if (order.status == 1) {
        total += int.parse('${order.products.kyat}');
      }
    }
    return total;
  }

  int calculateTotalPae() {
    int total = 0;
    for (var order in _orderList) {
      if (order.status == 1) {
        total += int.parse('${order.products.pae}');
      }
    }
    return total;
  }

  int calculateTotalYway() {
    int total = 0;
    for (var order in _orderList) {
      if (order.status == 1) {
        total += int.parse('${order.products.yway}');
      }
    }
    return total;
  }

  @override
  void initState() {
    getOrder().then((value) {
      setState(() {
        totalPrice = calculateTotalPrice();
        totalKyat = calculateTotalKyat();
        totalPae = calculateTotalPae();
        totalYway = calculateTotalYway();

        // Convert Yway to Pae
        int ywayToPae = totalYway ~/ 8;
        totalPae += ywayToPae;
        totalYway %= 8;

        // Convert Pae to Kyat
        int paeToKyat = totalPae ~/ 16;
        totalKyat += paeToKyat;
        totalPae %= 16;

        print('Sum price $totalPrice');
        print('Sum Kyat $totalKyat');
        print('Sum Pae $totalPae');
        print('Sum Yway $totalYway');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filterOrders = _orderList.where((order) {
      return selectCategory.isEmpty || selectCategory.contains(order.status);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Orders List',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back arrow press if needed
            Navigator.pop(context);
          },
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                setState(() {
                  getOrder().then((value) {
                    totalPrice = calculateTotalPrice();
                    totalKyat = calculateTotalKyat();
                    totalPae = calculateTotalPae();
                    totalYway = calculateTotalYway();
                    // Convert Yway to Pae
                    int ywayToPae = totalYway ~/ 8;
                    totalPae += ywayToPae;
                    totalYway %= 8;

                    // Convert Pae to Kyat
                    int paeToKyat = totalPae ~/ 16;
                    totalKyat += paeToKyat;
                    totalPae %= 16;
                  });
                });
                return getOrder();
              },
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: MyTheme.splash_screen_color),
                    padding: const EdgeInsets.only(
                        top: 0, left: 15, right: 15, bottom: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            controller: _searchController,
                            onChanged: (value) {
                              _orderList;
                              getOrder();
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search...',
                              hintStyle: const TextStyle(
                                height: 4,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  getOrder();
                                },
                              ),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  // Perform the search here
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
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
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'စာရင်းရှိရွှေ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Ks  ${formatter.format(totalPrice)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple[500],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$totalKyat ကျပ်',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent[700],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$totalPae ပဲ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$totalYway ရွေး',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: Colors.black12,
                    child: Row(
                      children: categoriesName.keys
                          .map((category) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: FilterChip(
                                    selected: selectCategory.contains(category),
                                    label: Text(categoriesName[category]!),
                                    checkmarkColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    selectedColor: Colors.blue,
                                    labelStyle: TextStyle(
                                      color: selectCategory.contains(category)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectCategory.add(category);
                                        } else {
                                          selectCategory.remove(category);
                                        }
                                      });
                                    }),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: _orderList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filterOrders.length,
                            itemBuilder: (context, index) {
                              Order order = filterOrders[index];
                              DateTime dateTime =
                                  DateTime.parse(order.createAt!);
                              String formattedOrderDate =
                                  DateFormat('y-MMM-d').format(dateTime);
                              return InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.black.withOpacity(.08),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          order.products!.image!.isNotEmpty
                                              ? SizedBox(
                                                  height: 60,
                                                  width: 60,
                                                  child: CachedNetworkImage(
                                                    imageUrl: order.products!
                                                            .image![0].url ??
                                                        '',
                                                    fit: BoxFit.fitWidth,
                                                    fadeInDuration:
                                                        const Duration(
                                                            seconds: 5),
                                                    maxHeightDiskCache: 1000,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                            progress) {
                                                      return ColoredBox(
                                                        color: Colors.black12,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  value: progress
                                                                      .progress),
                                                        ),
                                                      );
                                                    },
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                                  height: 80,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.45,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 130,
                                                        child: Text(
                                                          '${order.products!.productName}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            size: 14,
                                                            color: Colors.blue,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            formattedOrderDate,
                                                            style:
                                                                const TextStyle(
                                                              height: 1.8,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 6,
                                                                bottom: 6),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(31,
                                                                148, 148, 253),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '${order.products!.kyat} ကျပ် | ',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${order.products!.pae} ',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const Text(
                                                              'ပဲ | ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${order.products!.yway} ရွေး ',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Ks ${formatter.format(order.confirmPrice!)}',
                                                      style: const TextStyle(
                                                        height: 1.8,
                                                        fontSize: 16,
                                                        color: Colors
                                                            .blueGrey, // Replace with your desired color
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    order.status == 1
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            child: const Text(
                                                              'Complete',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .amber,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            child: const Text(
                                                              'Pending',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/images/nodata.png',
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                    ),
                                  ),
                                  const Text(
                                    'Order Not Found',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
