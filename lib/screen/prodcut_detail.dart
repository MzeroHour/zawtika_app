import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawtika/app_config/my_theme.dart';
import 'package:zawtika/data_model/order_model.dart';
import 'package:zawtika/repository/order_repository.dart';
import 'package:zawtika/screen/order_list_screen.dart';

import '../custom/toast_message.dart';
import '../data_model/prodcut_model.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int userId = 0;
  final TextEditingController _remarkController = TextEditingController();

  Future<void> submitOrder(Order order) async {
    try {
      await orderSubmit(order);
      toastMessage('Submit Order Successfully', Colors.white, Colors.green);
    } catch (error) {
      print(error);
      toastMessage('$error', Colors.white, Colors.grey[600]!);
    }
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id') ?? 0;
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.product.productName}',
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      widget.product.image!.isNotEmpty
                          ? SizedBox(
                              height: 250,
                              child: CachedNetworkImage(
                                imageUrl: widget.product.image![0].url ?? '',
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
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "${widget.product.productName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 10, bottom: 10, right: 20),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.product.price} Ks",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      color: Colors.indigo.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.coins,
                                    size: 19,
                                    color: Color.fromARGB(255, 255, 122, 0),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${widget.product.kyat} ကျပ်",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      color: Colors.indigo.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.coins,
                                    size: 19,
                                    color: Color.fromARGB(255, 255, 122, 0),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${widget.product.pae}  ပဲ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      color: Colors.indigo.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.coins,
                                    size: 19,
                                    color: Color.fromARGB(255, 255, 122, 0),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    " ${widget.product.yway} ရွေး",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          '${widget.product.description}',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.black26,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FontAwesomeIcons.checkCircle,
                                size: 60,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                MyTheme.thanks,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyTheme.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: _remarkController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                maxLength: null,
                                autocorrect: false,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade100,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Remark...',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  hintStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Order orderList;
                                        setState(
                                          () {
                                            orderList = Order(
                                              confirmPrice: int.parse(
                                                  '${widget.product.price}'),
                                              status: 1,
                                              remark: _remarkController.text,
                                              orgPrice: 0,
                                              itemId: widget.product.id,
                                              userId: userId,
                                            );
                                            submitOrder(orderList);
                                          },
                                        );
                                        Navigator.pushAndRemoveUntil<void>(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const OrderListScreen()),
                                          ModalRoute.withName('/home'),
                                        );
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 122, 0),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 122, 0),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.shoppingBasket,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Order Submit',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
