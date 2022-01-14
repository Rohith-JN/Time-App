import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({Key? key}) : super(key: key);

  @override
  _RegionSelectScreenState createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: null,
          backgroundColor: Colors.grey[900],
          title: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          icon: const Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        hintText: 'Search...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: InputBorder.none)),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 258.0),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.search,
                size: 160.0,
                color: Colors.white24,
              ),
              Text(
                "Search for a city",
                style: GoogleFonts.lato(fontSize: 25.0, color: Colors.white24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
