import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team6/basic_information.dart';
import 'package:team6/control_app.dart';
import 'package:team6/map_page.dart';
import 'package:team6/shared_widgets.dart';

class CVSPage extends ConsumerStatefulWidget {
  const CVSPage({super.key});

  @override
  ConsumerState<CVSPage> createState() => _CVSPageState();
}

class _CVSPageState extends ConsumerState<CVSPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: category.length + 1, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            child: Text(
              provider.selectedStore.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            width: size.width,
            height: 50,
            child: TabBar(
                controller: tabController,
                tabs: List.generate(category.length + 1, (index) {
                  if (index == 0) {
                    return const Tab(
                      text: "All",
                    );
                  }
                  return Tab(
                    text: category[index - 1],
                  );
                })),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: List.generate(category.length + 1, (index) {
                  if (index == 0) {
                    return const CVSItemsAll();
                  }
                  return CVSItems(categoryIndex: index - 1);
                })),
          ),
        ],
      ),
    );
  }
}

class CVSItemsAll extends ConsumerWidget {
  const CVSItemsAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return (provider.selectedStore.products.isEmpty)
        ? const Center(
            child: Text("Prodcut Not Exist"),
          )
        : SingleChildScrollView(
            child: Column(
              children: List.generate(
                  (provider.selectedStore.products.length - 1) ~/
                          (size.width ~/ 270) +
                      1, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(size.width ~/ 270, (iindex) {
                    if (index * (size.width ~/ 270) + iindex <
                        provider.selectedStore.products.length) {
                      return CVSProduct(
                          categoryIndex: -1,
                          productIndex: index * (size.width ~/ 270) + iindex);
                    }
                    return Container(
                      width: 230,
                      height: 280,
                      margin: const EdgeInsets.all(20),
                    );
                  }),
                );
              }),
            ),
          );
  }
}

class CVSItems extends ConsumerWidget {
  const CVSItems({super.key, required this.categoryIndex});
  final int categoryIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return (provider.selectedStore
                    .productForCategory[category[categoryIndex]] ==
                null ||
            provider.selectedStore.productForCategory[category[categoryIndex]]!
                .isEmpty)
        ? const Center(
            child: Text("Prodcut Not Exist"),
          )
        : SingleChildScrollView(
            child: Column(
              children: List.generate(
                  (provider
                                  .selectedStore
                                  .productForCategory[category[categoryIndex]]!
                                  .length -
                              1) ~/
                          (size.width ~/ 270) +
                      1, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(size.width ~/ 270, (iindex) {
                    if (index * (size.width ~/ 270) + iindex <
                        provider
                            .selectedStore
                            .productForCategory[category[categoryIndex]]!
                            .length) {
                      return CVSProduct(
                          categoryIndex: categoryIndex,
                          productIndex: index * (size.width ~/ 270) + iindex);
                    }
                    return Container(
                      width: 230,
                      height: 280,
                      margin: const EdgeInsets.all(20),
                    );
                  }),
                );
              }),
            ),
          );
  }
}

class CVSProduct extends ConsumerWidget {
  const CVSProduct(
      {super.key, required this.categoryIndex, required this.productIndex});
  final int categoryIndex;
  final int productIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  TextEditingController tcontroller = TextEditingController();
                  return AlertDialog(
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            int result = 0;
                            Future(() async {
                              result = await provider.buy(
                                  int.parse(tcontroller.text),
                                  categoryIndex == -1
                                      ? provider
                                          .selectedStore.products[productIndex]
                                      : provider
                                              .selectedStore.productForCategory[
                                          category[
                                              categoryIndex]]![productIndex],
                                  provider.selectedStore.id!);
                            }).then(
                              (value) {
                                if (result == 1) {
                                  context.pop();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text("결제 성공"),
                                        );
                                      });
                                } else {
                                  context.pop();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text("결제 실패"),
                                        );
                                      });
                                }
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color1,
                          ),
                          child: const Text("결제하기"))
                    ],
                    content: Container(
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            width: 280,
                            height: 30,
                            child: Center(
                              child: Text(categoryIndex == -1
                                  ? provider.selectedStore
                                      .products[productIndex].name!
                                  : provider
                                      .selectedStore
                                      .productForCategory[category[
                                          categoryIndex]]![productIndex]
                                      .name!),
                            ),
                          ),
                          Container(
                            width: 280,
                            height: 30,
                            child: Center(
                              child: Text(provider.selectedStore.name!),
                            ),
                          ),
                          Container(
                            width: 280,
                            height: 50,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextField(
                                controller: tcontroller,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            width: 230,
            height: 280,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: color2,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.grey,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 260,
                  height: 150,
                  child: Image.network(
                    categoryIndex == -1
                        ? provider.selectedStore.products[productIndex]
                                .imageUrl ??
                            "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763"
                        : provider
                                .selectedStore
                                .productForCategory[category[categoryIndex]]![
                                    productIndex]
                                .imageUrl ??
                            "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763",
                  ),
                ),
                Text(
                    "상품명 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].name : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].name}"),
                Text(
                    "가격 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].price : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].price}"),
                Text(
                    "수량 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].quantity : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].quantity}"),
              ],
            ),
          ),
        ),
        (categoryIndex == -1
                ? provider.selectedStore.products[productIndex].hasEvent!
                : provider
                    .selectedStore
                    .productForCategory[category[categoryIndex]]![productIndex]
                    .hasEvent!)
            ? Positioned(
                left: 30,
                top: 30,
                child: EventLogo(
                  id: (categoryIndex == -1
                      ? provider.selectedStore.products[productIndex].id!
                      : provider
                          .selectedStore
                          .productForCategory[category[categoryIndex]]![
                              productIndex]
                          .id!),
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
                onPressed: () {
                  provider.favoriteModyfy(
                      provider.selectedStore.id!,
                      (categoryIndex == -1
                          ? provider.selectedStore.products[productIndex]
                          : provider.selectedStore.productForCategory[
                              category[categoryIndex]]![productIndex]));
                },
                icon: (categoryIndex == -1
                        ? provider
                            .selectedStore.products[productIndex].hasFavorite!
                        : provider
                            .selectedStore
                            .productForCategory[category[categoryIndex]]![
                                productIndex]
                            .hasFavorite!)
                    ? Icon(
                        Icons.favorite,
                        color: color1,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: color1,
                      ))),
      ],
    );
  }
}

class EventLogo extends ConsumerWidget {
  const EventLogo({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return GestureDetector(
      onTap: () {
        provider.getEvent(id);
        showDialog(
          context: context,
          builder: (context) {
            return const EventDetail();
          },
        );
      },
      child: Container(
          width: 40,
          height: 40,
          child: const FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.star_rounded,
              color: Colors.yellow,
            ),
          )),
    );
  }
}

class EventDetail extends ConsumerWidget {
  const EventDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return AlertDialog(
      title: Text("Event"),
      content: Container(
        width: 400,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(provider.presentEvent.length, (index) {
              return IndividualEvent(index: index);
            }),
          ),
        ),
      ),
    );
  }
}

class IndividualEvent extends ConsumerWidget {
  const IndividualEvent({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return Container(
      width: 312,
      height: 202,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color5,
          border: Border.all(color: color2),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 80,
                child: Image.network(
                  provider.events[index].imageUrl ??
                      "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763",
                ),
              ),
              Container(
                width: 190,
                height: 80,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 190,
                      height: 30,
                      child: Text(
                        provider.presentEvent[index].name ?? "Event Name",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 50,
                      child: Column(
                        children: [
                          Text(provider.presentEvent[index].estart ??
                              "2023.01.01"),
                          Text(provider.presentEvent[index].eend ??
                              "2023.12.31"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 290,
            height: 90,
            margin: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
                child: Text(provider.presentEvent[index].policy ?? "policy")),
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CVSListPage extends ConsumerStatefulWidget {
  const CVSListPage({super.key});

  @override
  ConsumerState<CVSListPage> createState() => _CVSListPageState();
}

class _CVSListPageState extends ConsumerState<CVSListPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: category.length + 1, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            child: Text(
              provider.selectedStore.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            width: size.width,
            height: 50,
            child: TabBar(
                controller: tabController,
                tabs: List.generate(category.length + 1, (index) {
                  if (index == 0) {
                    return const Tab(
                      text: "All",
                    );
                  }
                  return Tab(
                    text: category[index - 1],
                  );
                })),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: List.generate(category.length + 1, (index) {
                  if (index == 0) {
                    return const OCVSItemsAll();
                  }
                  return OCVSItems(categoryIndex: index - 1);
                })),
          ),
        ],
      ),
    );
  }
}

class OCVSItemsAll extends ConsumerWidget {
  const OCVSItemsAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return (provider.selectedStore.products.isEmpty)
        ? const Center(
            child: Text("Prodcut Not Exist"),
          )
        : SingleChildScrollView(
            child: Column(
              children: List.generate(
                  (provider.selectedStore.products.length - 1) ~/
                          (size.width ~/ 270) +
                      1, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(size.width ~/ 270, (iindex) {
                    if (index * (size.width ~/ 270) + iindex <
                        provider.selectedStore.products.length) {
                      return OCVSProduct(
                          categoryIndex: -1,
                          productIndex: index * (size.width ~/ 270) + iindex);
                    }
                    return Container(
                      width: 230,
                      height: 280,
                      margin: const EdgeInsets.all(20),
                    );
                  }),
                );
              }),
            ),
          );
  }
}

class OCVSItems extends ConsumerWidget {
  const OCVSItems({super.key, required this.categoryIndex});
  final int categoryIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return (provider.selectedStore
                    .productForCategory[category[categoryIndex]] ==
                null ||
            provider.selectedStore.productForCategory[category[categoryIndex]]!
                .isEmpty)
        ? const Center(
            child: Text("Prodcut Not Exist"),
          )
        : SingleChildScrollView(
            child: Column(
              children: List.generate(
                  (provider
                                  .selectedStore
                                  .productForCategory[category[categoryIndex]]!
                                  .length -
                              1) ~/
                          (size.width ~/ 270) +
                      1, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(size.width ~/ 270, (iindex) {
                    if (index * (size.width ~/ 270) + iindex <
                        provider
                            .selectedStore
                            .productForCategory[category[categoryIndex]]!
                            .length) {
                      return OCVSProduct(
                          categoryIndex: categoryIndex,
                          productIndex: index * (size.width ~/ 270) + iindex);
                    }
                    return Container(
                      width: 230,
                      height: 280,
                      margin: const EdgeInsets.all(20),
                    );
                  }),
                );
              }),
            ),
          );
  }
}

class OCVSProduct extends ConsumerWidget {
  const OCVSProduct(
      {super.key, required this.categoryIndex, required this.productIndex});
  final int categoryIndex;
  final int productIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(viewmodel);
    return Stack(
      children: [
        Container(
          width: 230,
          height: 280,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: color2,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 260,
                height: 150,
                child: Image.network(
                  categoryIndex == -1
                      ? provider
                              .selectedStore.products[productIndex].imageUrl ??
                          "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763"
                      : provider
                              .selectedStore
                              .productForCategory[category[categoryIndex]]![
                                  productIndex]
                              .imageUrl ??
                          "https://gdimg.gmarket.co.kr/3014545259/still/400?ver=1687144763",
                ),
              ),
              Text(
                  "상품명 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].name : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].name}"),
              Text(
                  "가격 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].price : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].price}"),
              Text(
                  "수량 : ${categoryIndex == -1 ? provider.selectedStore.products[productIndex].quantity : provider.selectedStore.productForCategory[category[categoryIndex]]![productIndex].quantity}"),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController tcontroller =
                            TextEditingController();
                        return AlertDialog(
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  int result = 0;
                                  Future(() async {
                                    result = await provider.addOrder(
                                        int.parse(tcontroller.text),
                                        DateTime.now()
                                            .add(const Duration(days: 7))
                                            .toString()
                                            .substring(0, 19),
                                        "Waiting",
                                        categoryIndex == -1
                                            ? provider.selectedStore
                                                .products[productIndex]
                                            : provider.selectedStore
                                                        .productForCategory[
                                                    category[categoryIndex]]![
                                                productIndex],
                                        provider.selectedStore.id!);
                                  }).then(
                                    (value) {
                                      if (result == 1) {
                                        context.pop();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: Center(
                                                    child: Text("주문 성공")),
                                              );
                                            });
                                      } else {
                                        context.pop();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: Center(
                                                    child: Text("주문 실패")),
                                              );
                                            });
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color1,
                                ),
                                child: const Text("주문하기"))
                          ],
                          content: Container(
                            width: 300,
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 280,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                        categoryIndex == -1
                                            ? provider.selectedStore
                                                .products[productIndex].name!
                                            : provider
                                                .selectedStore
                                                .productForCategory[
                                                    category[categoryIndex]]![
                                                    productIndex]
                                                .name!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                                Container(
                                  width: 280,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      provider.selectedStore.name!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 50,
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      child: Center(child: Text("수량", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400
                                      ),)),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          controller: tcontroller,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.add))),
      ],
    );
  }
}
