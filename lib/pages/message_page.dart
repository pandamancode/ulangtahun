import 'package:birthday/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

// ignore: must_be_immutable
class MessagePage extends StatefulWidget {
  String? nrp;
  String? nama;
  String? jabatan;
  String? usia;
  String? whatsappNumber;
  String? fulljabatan;
  String? foto;

  MessagePage(this.nrp, this.nama, this.jabatan, this.usia, this.whatsappNumber, this.fulljabatan,
      this.foto,
      {super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController pesanController = TextEditingController();

  String? pesanTeks;

  void sendWhatsapp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+62${widget.whatsappNumber}',
      text: pesanController.text.toString(),
    );
    // ignore: deprecated_member_use
    await launch('$link');
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      pesanTeks = preferences.getString("pesan");
      String fullname = "${widget.jabatan} ${widget.nama}";
      String repNama = pesanTeks!.replaceAll('[nama]', fullname);
      String fullMessage = repNama.replaceAll('[umur]', widget.usia.toString());
      pesanController.text = fullMessage.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
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
                          Expanded(
                            flex: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.nama}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "${widget.nrp} / ${widget.jabatan}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${widget.fulljabatan}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "Umur ${widget.usia}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            controller: pesanController,
                            minLines: 4,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Pesan',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                          const SizedBox(
                            height: 8,
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
