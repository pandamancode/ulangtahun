import 'package:birthday/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class MessagePage extends StatefulWidget {
  String? nrp;
  String? nama;
  String? jabatan;
  String? usia;
  String? whatsappNumber;
  String? foto;

  MessagePage(this.nrp, this.nama, this.jabatan, this.usia, this.whatsappNumber,
      this.foto,
      {super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController pesanController = TextEditingController();

  void sendWhatsapp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+62' + widget.whatsappNumber.toString(),
      text: pesanController.text.toString(),
    );
    await launch('$link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        title: Text(
          "Kirim Pesan Ucapan",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              backgroundImage(),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Card(
                      color: mainColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.foto.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.nama}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${widget.nrp}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${widget.jabatan}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${widget.usia}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    color: mainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: pesanController,
                            minLines: 4,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Pesan',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              suffixIcon: Icon(
                                Icons.message,
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              sendWhatsapp();
                            },
                            icon: const Icon(Icons.whatsapp),
                            label: const Text("Kirim Pesan"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondColor,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backgroundImage() {
    return Container(
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
}