import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team6/control_app.dart';
import 'package:team6/shared_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String id = "";
  String pw = "";
  String state = "client";
  bool sbool = false;
  bool loginState = true;
  int loginResult = 0;
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(viewmodel);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(10),
                child: FittedBox(fit: BoxFit.fill, child: Image.asset('assets/TeamLogo.png', color: color2,)),
              ),
              AnimatedContainer(
                width: 320,
                height: 261 + (loginState ? 0 : 20),
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
                                onChanged: (value) {
                                  id = value;
                                },
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
                                onChanged: (value) {
                                  pw = value;
                                },
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
                      width: 300,
                      height: loginState ? 0 : 20,
                      duration: const Duration(milliseconds: 400),
                      child: Align(
                        alignment: const Alignment(0.9, 0),
                        child: Text(
                          (loginResult < -1)
                              ? "Server Error"
                              : ((loginResult == 0)
                                  ? "Password Incorrect"
                                  : "Id Incorrect"),
                          style: const TextStyle(color: Colors.red),
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
                                  text: " 로 로그인",
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
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          Future(() async {
                            loginResult = await provider.login(id, pw, state);
                          }).then(
                            (value) {
                              setState(() {
                                if (loginResult > 0) {
                                  if (provider.state == 'client') {
                                    context.go('/MAP');
                                    provider.cvsLocation();
                                    provider.eventList();
                                  } else {
                                    context.go('/OwnerProfile');
                                    provider.getMyCVS();
                                  }
                                } else {
                                  loginState = false;
                                }
                              });
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: color2,
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Text(
                          "로그인",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/SignUp');
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
            ],
          ),
        ),
      ),
    );
  }
}
