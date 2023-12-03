import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            width: 800,
            height: 600,
            margin: EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(10, (index) {
                  return MyFavorite();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFavorite extends ConsumerWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: 150,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
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
            child: Text(
              "상품이미지",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 300,
                height: 30,
                // color: Colors.pink,
                margin: EdgeInsets.only(top: 10),
                child: const Text(
                  "GS산격점",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 100,
                // color: Colors.pink,
                child: const Text(
                  "상품명",
                  style: TextStyle(
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
                width: 200,
                height: 40,
                // color: Colors.pink,
                margin: EdgeInsets.only(top: 40),
                child: const Text(
                  //provider.myFavorites[index].quantity == 0 ? :
                  "현재수량 :",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 60,
                child: Text("예상 도착시간: "),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
