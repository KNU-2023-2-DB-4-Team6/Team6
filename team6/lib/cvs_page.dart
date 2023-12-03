import 'package:flutter/material.dart';
import 'package:team6/basic_information.dart';
import 'package:team6/shared_widgets.dart';

class CVSPage extends StatefulWidget {
  const CVSPage({super.key});

  @override
  State<CVSPage> createState() => _CVSPageState();
}

class _CVSPageState extends State<CVSPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: category.length, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            width: size.width - 100,
            height: 50,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: color3,
            ),
            child: TextField(),
          ),
          Container(
            width: size.width,
            height: 50,
            child: TabBar(
                controller: tabController,
                tabs: List.generate(category.length, (index) {
                  return Tab(
                    text: category[index],
                  );
                })),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: List.generate(category.length, (index) {
                  return CVSItems();
                })),
          ),
        ],
      ),
    );
  }
}

class CVSItems extends StatelessWidget {
  const CVSItems({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: List.generate(4, (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(size.width ~/ 270, (iindex) {
              return const CVSProduct();
            }),
          );
        }),
      ),
    );
  }
}

class CVSProduct extends StatelessWidget {
  const CVSProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 230,
          height: 280,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color2,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("제품사진"),
              Text("상품명"),
              Text("가격"),
              Text("수량"),
            ],
          ),
        ),
        Positioned(
          left: 30,
          top: 30,
          child: EventLogo(),
        ),
      ],
    );
  }
}

class EventLogo extends StatelessWidget {
  const EventLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return const EventDetail();
          },
        );
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class EventDetail extends StatelessWidget {
  const EventDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Event"),
      content: Text("Event content"),
    );
  }
}
