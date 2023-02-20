import 'package:birthday/pages/home_page.dart';
import 'package:birthday/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  String? val;
  TextEditingController uName = TextEditingController();
  TextEditingController passWord = TextEditingController();

  LoginStatus _loginStatus = LoginStatus.notSignIn;

  bool _loading = false;

  void logiN() async {
    setState(() {
      _loading = true;
    });

    final response = await http.post(
        Uri.parse("http://ulayyasoft.my.id/sdm/user/login"),
        body: {"uname": uName.text, "password": passWord.text});
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });

      final data = jsonDecode(response.body);
      String value = data[0]["status"];

      if (value == 'success') {
        String unameApi = data[0]["data"]["uname"];
        String namaApi = data[0]["data"]["nama"];
        String msgApi = data[0]["data"]["pesan"];
        setState(() {
          _loginStatus = LoginStatus.signIn;
          String stts = "1";
          savePref(value, stts, unameApi, namaApi, msgApi);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("Username atau Password Salah"),
              actions: [
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _loading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Gagal"),
            content: const Text("Periksa Koneksi Internet"),
            actions: [
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          );
        },
      );
    }
  }

  savePref(String value, String status, String username, String name,
      String pesan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("value", value);
      preferences.setString("status", status);
      preferences.setString("nama", name);
      preferences.setString("uname", username);
      preferences.setString("pesan", pesan);
    });
  }

  //var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      val = preferences.getString("status");

      _loginStatus = val == "1" ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("status", "0");
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (_loginStatus == LoginStatus.signIn) {
      return gotoHome();
    } else {
      return (_loading == true) ? loadingMsg() : mainForm();
    }
  }

  Widget gotoHome() {
    return HomePage(signOut);
  }

  Widget mainForm() {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor,Color.fromARGB(255, 236, 194, 131)],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(
                        child: Image.asset(
                          'assets/bg.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 2 / 6,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height * 2 / 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        spreadRadius: 0,
                        blurRadius: 1.8,
                      )
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 2 / 6,
                ),
                child: loginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingMsg() {
    return Scaffold(
      backgroundColor: mainColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            Text(
              "Please Wait",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height * 2 / 6),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
                  "Login Area",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
                  "Login ke Akun Anda",
                  style: GoogleFonts.poppins(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextFormField(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  controller: uName,
                  maxLength: 16,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFF2F2F2),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                    hintText: 'username',
                    labelText: 'Username',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    suffixStyle: const TextStyle(color: Colors.black),
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintStyle: GoogleFonts.poppins().copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextFormField(
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  obscureText: true,
                  controller: passWord,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFF2F2F2),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                    hintText: '*****',
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    hintStyle: GoogleFonts.poppins().copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.orangeAccent,
                      onTap: () {
                        logiN();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: secondColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 0,
                              blurRadius: 1.8,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
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
