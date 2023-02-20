import 'package:birthday/pages/login_page.dart';
import 'package:birthday/pages/personil_page.dart';
import 'package:birthday/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  //const HomePage({super.key});
  final VoidCallback signOut;
  const HomePage(this.signOut, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  savePref(String golongan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("golongan", golongan);
    });
  }

  void logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("status");
      preferences.remove("nama");
      preferences.remove("pesan");
      preferences.remove("uname");
    });
  }

  void exitApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Yakin Ingin Keluar dari Aplikasi?"),
          actions: [
            TextButton(
              child: const Text("Ya"),
              onPressed: () {
                logOut();
                widget.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            backgroundImage(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
                color: secondColor,
              ),
              child: Center(
                child: Text(
                  "Birthday App",
                  style: GoogleFonts.pacifico(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            listGolongan(),
            footer(),
          ],
        ),
      ),
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
          image: AssetImage("assets/bg.png"),
          opacity: 0.1,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget listGolongan() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 114,
        left: 14,
        right: 14,
      ),
      child: Column(
        children: [
          Card(
            color: mainColor,
            child: GestureDetector(
              onTap: () {
                savePref('PATI');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PersonilPage();
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "PATI",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Perwira Tinggi",
                  style: GoogleFonts.poppins(),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            color: mainColor,
            child: GestureDetector(
              onTap: () {
                savePref('PAMEN');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PersonilPage();
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "PAMEN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Perwira Menengah",
                  style: GoogleFonts.poppins(),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            color: mainColor,
            child: GestureDetector(
              onTap: () {
                savePref('PAMA');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PersonilPage();
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "PAMA",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Perwira Pertama",
                  style: GoogleFonts.poppins(),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
          Card(
            color: mainColor,
            child: GestureDetector(
              onTap: () {
                savePref('BINTARA');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PersonilPage();
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "BINTARA",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Bintara",
                  style: GoogleFonts.poppins(),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),

          InkWell(
            onTap: (){
              exitApp();
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(Icons.exit_to_app,color: Colors.white,),
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget footer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
          child: Text(
            "Copyright \u00a9 Polda Lampung 2023",
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
