import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'control_app.dart';
import 'shared_widgets.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController idcontroller = TextEditingController();
  TextEditingController pwcontroller = TextEditingController();
  TextEditingController locXcontroller = TextEditingController();
  TextEditingController locYcontroller = TextEditingController();
  String state = "client";
  bool sbool = false;
  bool signUpstate = true;
  int signUpResult = 0;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(viewmodel);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedContainer(
          width: 320,
          height: 271 + 60 + 30 + (signUpstate ? 0 : 20),
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: color2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: 300,
                height: 101,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 280,
                      height: 49,
                      child: Center(
                        child: TextField(
                          controller: idcontroller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "아이디",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 280,
                      height: 49,
                      child: Center(
                        child: TextField(
                          controller: pwcontroller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "비밀번호",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: signUpstate ? 0 : 20,
                width: 300,
                duration: const Duration(milliseconds: 400),
                child: Align(
                  alignment: const Alignment(0.9, 0),
                  child: Text(
                    signUpResult == 1
                        ? "success"
                        : (signUpResult == -1
                            ? "id duplicate"
                            : "server error"),
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: state,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        children: const [
                          TextSpan(
                            text: " 로 회원가입",
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 30,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CupertinoSwitch(
                          value: sbool,
                          activeColor: color1,
                          onChanged: (value) {
                            setState(() {
                              state = value ? "owner" : "client";
                              sbool = value;
                              locXcontroller.text = "";
                              locYcontroller.text = "";
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 49,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sbool ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: locXcontroller,
                    readOnly: sbool,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Location_X",
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 49,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sbool ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: locYcontroller,
                    readOnly: sbool,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Location_Y",
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: const Alignment(1, 0),
                  child: TextButton(
                    onPressed: sbool
                        ? null
                        : () {
                            locXcontroller.text = "35.8662";
                            locYcontroller.text = "128.6001";
                          },
                    child: Text(
                      "내 위치로 지정하기",
                      style: TextStyle(
                        color: sbool ? Colors.white : color2,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                  onPressed: () {
                    Future(() async {
                      signUpResult = await provider.signUp(
                          idcontroller.text,
                          pwcontroller.text,
                          state,
                          double.parse(locXcontroller.text == ""
                              ? "0"
                              : locXcontroller.text),
                          double.parse(locYcontroller.text == ""
                              ? "0"
                              : locYcontroller.text));
                    }).then((value) {
                      setState(() {
                        if (signUpResult > 0) {
                          signUpstate = true;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("로그인 성공"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          context.go('/Map');
                                        },
                                        child: Text("확인", style: TextStyle(
                                          color: Colors.black,
                                        ),))
                                  ],
                                );
                              });
                        } else {
                          signUpstate = false;
                        }
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: color1,
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text(
                    "회원가입",
                    style: TextStyle(color: Colors.white),
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
