import 'package:flutter/material.dart';

class AddCVSPage extends StatefulWidget {
  const AddCVSPage({super.key});

  @override
  State<AddCVSPage> createState() => _AddCVSPageState();
}

class _AddCVSPageState extends State<AddCVSPage> {
  List<TextEditingController> controllers = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: Column(
          children: [
            CustomTextField(controller: controllers[0]),
            CustomTextField(controller: controllers[1]),
            CustomTextField(controller: controllers[2]),
            CustomTextField(controller: controllers[3]),
            CustomTextField(controller: controllers[4]),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(controller: widget.controller),
    );
  }
}
