import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team6/class/models.dart';
import 'package:team6/control_app.dart';
import 'package:team6/shared_widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: 1000,
          height: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: Text(
                  "${provider.me.cId!}의 Favorites",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 800,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(provider.myFavorites.length, (index) {
                      return MyFavorite(
                        index: index,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFavorite extends ConsumerWidget {
  const MyFavorite({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(viewmodel);
    return Container(
      width: size.width * 0.9,
      height: 152,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color2),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Color(0xFF909090),
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              width: 130,
              height: 130,
              // color: Colors.pink,
              child: Image.network(provider.myFavorites[index].imageUrl ??
                  "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763")),
          Column(
            children: [
              Container(
                width: 300,
                height: 30,
                // color: Colors.pink,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  provider.myFavorites[index].cvsName ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 100,
                // color: Colors.pink,
                child: Text(
                  provider.myFavorites[index].pName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 300,
                height: 40,
                // color: Colors.pink,
                margin: const EdgeInsets.only(top: 40),
                child: Text(
                  //provider.myFavorites[index].quantity == 0 ? :
                  "현재수량 : ${provider.myFavorites[index].quantity}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 60,
                child: Text(
                  provider.myFavorites[index].arrivalTime == null
                      ? ""
                      : "도착예정 시간 : ${provider.myFavorites[index].arrivalTime}",
                  style: TextStyle(color: color1, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OwnerProfile extends ConsumerWidget {
  const OwnerProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(viewmodel);
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: size.width * 0.6,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(provider.myCVS.length, (index) {
                return MyCVS(
                  index: index,
                );
              }),
            ),
          ),
        ),
        Container(
          width: size.width * 0.4 - 20,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: color2, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: size.width * 0.4 - 40,
                height: 100,
                child: Container(
                  width: size.width * 0.4 - 20,
                  height: 80,
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      provider.selectedStore.name ?? "",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        ((provider.selectedCondition == 'order'
                                        ? provider.myOrder.length
                                        : provider
                                            .selectedStore.products.length) -
                                    1) ~/
                                ((size.width * 0.4) ~/ 200) +
                            1, (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            List.generate((size.width * 0.4) ~/ 200, (iindex) {
                          if ((provider.selectedCondition == 'order'
                                      ? provider.myOrder.length
                                      : provider
                                          .selectedStore.products.length) -
                                  (index * ((size.width * 0.4) ~/ 200) +
                                      iindex) <=
                              0) {
                            return Container(
                              width: 200,
                              height: 320,
                              margin: const EdgeInsets.all(20),
                            );
                          }
                          if (provider.selectedCondition == 'order') {
                            return MyOrder(
                                index: index * ((size.width * 0.4) ~/ 200) +
                                    iindex);
                          } else {
                            return MyTopProduct(
                                index: index * ((size.width * 0.4) ~/ 200) +
                                    iindex);
                          }
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class MyOrder extends ConsumerWidget {
  const MyOrder({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return Container(
      width: 202,
      height: 322,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color2, width: 1),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Color(0xFF909090),
            )
          ]),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: Image.network(
              provider.myOrder[index].imageUrl!,
            ),
          ),
          Row(
            children: [
              Container(
                width: 70,
                height: 140,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("상품명"),
                    Text("가격"),
                    Text("수량"),
                    Text("카테고리"),
                    Text("도착상태"),
                    Text("도착날짜"),
                  ],
                ),
              ),
              Container(
                width: 110,
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.myOrder[index].pName ?? ""),
                    Text(provider.myOrder[index].pPrice.toString()),
                    Text(provider.myOrder[index].quantity.toString()),
                    Text(provider.myOrder[index].category ?? ""),
                    Text(provider.myOrder[index].arrivalState ?? ""),
                    Text(provider.myOrder[index].arrival == null
                        ? ""
                        : provider.myOrder[index].arrival!.substring(0, 10)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyTopProduct extends ConsumerWidget {
  const MyTopProduct({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return Container(
      width: 202,
      height: 322,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color2, width: 1),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Color(0xFF909090),
            )
          ]),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: Image.network(
              provider.selectedStore.products[index].imageUrl ??
                  "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763",
            ),
          ),
          Row(
            children: [
              Container(
                width: 70,
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index + 1} 위 상품"),
                    const Text("상품명"),
                    const Text("가격"),
                    const Text("수량"),
                    const Text("카테고리"),
                  ],
                ),
              ),
              Container(
                width: 110,
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("  "),
                    Text(provider.selectedStore.products[index].name ?? ""),
                    Text(provider.selectedStore.products[index].price
                        .toString()),
                    Text(provider.selectedStore.products[index].quantity
                        .toString()),
                    Text(
                      provider.selectedStore.products[index].category == null
                          ? ""
                          : provider.selectedStore.products[index].category!
                              .substring(
                                  0,
                                  min(
                                      provider.selectedStore.products[index]
                                          .category!.length,
                                      10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyCVS extends ConsumerWidget {
  const MyCVS({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(viewmodel);
    return Container(
      width: size.width * 0.6,
      height: 152,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color2),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Color(0xFF909090),
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: double.infinity,
            width: (size.width * 0.6 - 62) / 5,
            child: provider.myCVS[index].imageUrl == null
                ? const Placeholder()
                : Image.network(provider.myCVS[index].imageUrl!),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: double.infinity,
            width: (size.width * 0.6 - 62) / 5 * 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.myCVS[index].name!,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  provider.myCVS[index].address!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Tel.${provider.myCVS[index].pNumber}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "총 매출 액 : ${provider.myCVS[index].revenue.toString()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            width: (size.width * 0.6 - 62) / 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.storeInformation(provider.myCVS[index]);
                      context.go('/CVSList');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "물품 목록 확인",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.topProducts(provider.myCVS[index]);
                      provider.seletedConditionChange("topproducdt");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "매출상위 목록",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.seletedConditionChange("order");
                      provider.getMyOrder(provider.myCVS[index]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "발주 현황 확인",
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
