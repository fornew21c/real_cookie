import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:real_cookie/constants.dart';
import 'package:real_cookie/item_checkout_page.dart';
import 'package:real_cookie/models/product.dart';

class ItemBasketPage extends StatefulWidget {
  const ItemBasketPage({super.key});

  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {    

  
  List<Product> productList = [
    Product(
        productNo: 1,
        productName: "오레오 쿠키",
        productImageUrl: "https://picsum.photos/id/1/300/300",
        price: 2500),
    Product(
        productNo: 2,
        productName: "초코 쿠키",
        productImageUrl: "https://picsum.photos/id/20/300/300",
        price: 2500),
    Product(
        productNo: 3,
        productName: "르뱅 쿠키",
        productImageUrl: "https://picsum.photos/id/30/300/300",
        price: 3500),
    Product(
        productNo: 4,
        productName: "플레인 쿠키",
        productImageUrl: "https://picsum.photos/id/60/300/300",
        price: 2300),
    Product(
        productNo: 5,
        productName: "플레인 스콘",
        productImageUrl: "https://picsum.photos/id/75/200/300",
        price: 2500),
    Product(
        productNo: 6,
        productName: "얼그레이 스콘",
        productImageUrl: "https://picsum.photos/id/24/200/300",
        price: 2800),
  ];

  double totalPrice = 0;
  Map<String, dynamic> cartMap = {};

  @override
  void initState() {
    super.initState();

    //! 저장한 장바구니 리스트 가져오기
    cartMap = json.decode(sharedPreferences.getString("cartMap") ?? "{}") ?? {};
  }

  double calculateTotalPrice() {
    totalPrice = 0;
    //! 총액 계산
    for (int i = 0; i < cartMap.length; i++) {
      totalPrice += productList
              .firstWhere((element) =>
                  element.productNo == int.parse(cartMap.keys.elementAt(i)))
              .price! *
          cartMap[cartMap.keys.elementAt(i)];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("장바구니 페이지"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cartMap.length,
        itemBuilder: (context, index) {
          int productNo = int.parse(cartMap.keys.elementAt(index));
          Product currentProduct = productList
              .firstWhere((element) => element.productNo == productNo);
          return basketContainer(
              productNo: productNo,
              productName: currentProduct.productName ?? "",
              productImageUrl: currentProduct.productImageUrl ?? "",
              price: currentProduct.price ?? 0,
              quantity: cartMap[productNo.toString()]);
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            //! 결제시작 페이지로 이동
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const ItemCheckoutPage();
              },
            ));
          },
          child: Text("총 ${numberFormat.format(calculateTotalPrice())}원 결제하기"),
        ),
      ),
    );
  }

  Widget basketContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: productImageUrl,
            width: MediaQuery.of(context).size.width * 0.3,
            height: 130,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const Center(
                child: Text("오류 발생"),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  productName,
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${numberFormat.format(price)}원"),
                Row(
                  children: [
                    const Text("수량:"),
                    IconButton(
                      onPressed: () {
                        //! 수량 줄이기 (1 초과시에만 감소시킬 수 있음)
                        if (cartMap[productNo.toString()] > 1) {
                          setState(() {
                            //! 수량 1 차감
                            cartMap[productNo.toString()]--;

                            //! 디스크에 반영
                            sharedPreferences.setString(
                                "cartMap", json.encode(cartMap));
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                    ),
                    Text("$quantity"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          //! 수량 늘리기
                          cartMap[productNo.toString()]++;

                          //! 디스크에 반영
                          sharedPreferences.setString(
                              "cartMap", json.encode(cartMap));
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          //! 장바구니에서 해당 제품 제거
                          cartMap.remove(productNo.toString());

                          //! 디스크에 반영
                          sharedPreferences.setString(
                              "cartMap", json.encode(cartMap));
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ],
                ),
                Text("합계: ${numberFormat.format(price * quantity)}원"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}