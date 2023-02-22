import 'package:birthday/pages/message_page.dart';
import 'package:birthday/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TomorrowWidget extends StatefulWidget {
  const TomorrowWidget({super.key});

  @override
  State<TomorrowWidget> createState() => _TomorrowWidgetState();
}

class _TomorrowWidgetState extends State<TomorrowWidget> {
  String? golongan;
  bool loading = false;
  List result = [];
  String? _empty;
  String? path;
  String? fotoProfil =
      "http://ulayyasoft.my.id/sdm/public/images/default.png";

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      golongan = preferences.getString("golongan");
    });

    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.post(
          Uri.parse("http://ulayyasoft.my.id/sdm/personil/besok"),
          body: {"golongan": golongan});
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        if (data[0]['status'] == 'success') {
          setState(() {
            loading = false;
            result = data[0]['data'];
            _empty = "ada";
            path = data[0]['path'];
          });
        } else {
          setState(() {
            loading = false;
            result = data;
            _empty = "tidak";
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: secondColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ulang Tahun Besok',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '$golongan',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 95,
            left: 12,
            right: 12,
            bottom: 12,
          ),
          child: (loading == true) ? loadingWidget() : resultPersonil(),
        ),
      ],
    );
  }

  Widget backgroundImage() {
    return Container(
      margin: const EdgeInsets.only(
        top: 100,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/bg.png"),
          opacity: 0.1,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget resultPersonil() {
    return (_empty == 'ada')
        ? RefreshIndicator(
            onRefresh: loadData,
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                (result[index]['foto'] == null)
                    ? fotoProfil =
                        "http://ulayyasoft.my.id/sdm/public/images/default.png"
                    : fotoProfil = "$path/${result[index]['foto']}";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MessagePage(
                            result[index]['nrp'].toString(),
                            result[index]['nama'].toString(),
                            result[index]['jabatan'].toString(),
                            result[index]['umur'].toString(),
                            result[index]['whatsapp'].toString(),
                            fotoProfil.toString(),
                          );
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 115,
                    child: Card(
                      color: mainColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 90,
                            height: 115,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(fotoProfil.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${result[index]['nama']}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${result[index]['nrp']}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "${result[index]['jabatan']}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "${result[index]['umur']}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
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
              },
            ),
          )
        : kosong();
  }

  Widget kosong() {
    return (_empty == 'tidak')
        ? Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.black,
                  ),
                  Text(
                    "Data Tidak Ditemukan !",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget loadingWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
