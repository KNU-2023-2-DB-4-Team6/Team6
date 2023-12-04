import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:team6/control_app.dart';
import 'package:team6/shared_widgets.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(viewmodel);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: provider.myLocation,
                    zoom: 15.0,
                  ),
                  markers: Set.from(provider.markers),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/Profile');
                      provider.getMyFavorites();
                    },
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await provider.cvsLocation();
                      await provider.eventList();
                      setState(() {});
                    },
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.storefront_sharp,
                            color: color2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 40,
                  child: Container(
                    width: 750,
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: color2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: provider.selectedStore.imageUrl == null
                              ? const SizedBox(
                                  width: 10,
                                )
                              : Image.asset(provider.selectedStore.imageUrl!),
                        ),
                        Container(
                          width: 300,
                          height: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.selectedStore.name ?? "",
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                provider.selectedStore.address ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.selectedStore.pNumber ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 80,
                          child: OutlinedButton(
                            onPressed: () {
                              if (provider.selectedStore.id == null) {
                                return;
                              }
                              provider.storeInformation(provider.selectedStore);
                              context.push('/CVS');
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: color2,
                              side: BorderSide(
                                color: Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "편의점 바로가기",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/Waiting.png'),
    );
  }
}

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = ref.watch(viewmodel);
    return Container(
      height: size.height,
      width: 350,
      color: color5,
      child: Column(
        children: [
          Container(
            width: 350,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: color2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Autocomplete(
              optionsBuilder: (textEditingValue) async {
                await provider.searchList(textEditingValue.text);
                return provider.possibleProducts;
              },
              optionsMaxHeight: 500,
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "ProductName",
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: 230,
                      height: min(500, provider.possibleProducts.length * 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10.0),
                        itemCount: options.length,
                        separatorBuilder: (context, i) {
                          return const Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await provider
                                  .productCVS(provider.possibleProducts[index]);
                              setState(() {});
                            },
                            child: Container(
                              width: 230,
                              height: 30,
                              child: Text(
                                provider.possibleProducts[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(provider.events.length, (index) {
                  return SideBarCVS(index: index);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideBarCVS extends ConsumerWidget {
  const SideBarCVS({super.key, required this.index});
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
                        provider.events[index].name ?? "Event Name",
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
                          Text(provider.events[index].estart ?? "2023.01.01"),
                          Text(provider.events[index].eend ?? "2023.12.31"),
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
                child: Text(provider.events[index].policy ?? "policy")),
          ),
        ],
      ),
    );
  }
}
