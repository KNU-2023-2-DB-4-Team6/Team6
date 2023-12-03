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
      appBar: AppBar(),
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
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/Profile');
                    },
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey,
                        width: 50,
                        height: 50,
                        child: Center(child: Text("Profile")),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      await provider.cvsLocation();
                      await provider.eventList();
                      setState(() {});
                    },
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey,
                        width: 50,
                        height: 50,
                        child: Center(child: Text("CVS")),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 40,
                  child: Container(
                    width: size.width - 440,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(provider.selectedStore.name ?? ""),
                        Text(provider.selectedStore.address ?? ""),
                        Text(provider.selectedStore.pNumber ?? ""),
                        TextButton(
                          onPressed: (){
                            context.go('/CVS');
                          },
                          child: Text("편의점 바로가기"),
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
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Autocomplete(
              optionsBuilder: (textEditingValue) async {
                await provider.searchList(textEditingValue.text);
                return provider.possibleProducts;
              },
              optionsMaxHeight: 500,
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
                              print(index);
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
      width: 310,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color5,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      child: Column(
        children: [
          Text(provider.events[index].name ?? "Event Name"),
          Text(provider.events[index].estart ?? "2023.01.01"),
          Text(provider.events[index].eend ?? "2023.12.31"),
          Text(provider.events[index].policy ?? "policy"),
        ],
      ),
    );
  }
}
