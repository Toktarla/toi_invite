import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[900];
final myAppBar = AppBar(
  elevation: 0,
  backgroundColor: appBarColor,
  title: Text(' AppBar (:  '),
  centerTitle: false,
);
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var myDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  elevation: 0,
  child: Column(
    children: [
      const DrawerHeader(
        child: Icon(
          Icons.favorite,
          size: 64,
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'D A S H B O A R D',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'S E T T I N G S',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.info),
          title: Text(
            'A B O U T',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'L O G O U T',
            style: drawerTextColor,
          ),
        ),
      ),
    ],
  ),
);


TextStyle garamondStyle = GoogleFonts.ebGaramond(
  fontSize: 16,
);

TextStyle greatVibesStyle = GoogleFonts.greatVibes(
  fontSize: 16,
);

TextStyle heyheyStyle = GoogleFonts.pangolin(
  fontSize: 16,
);

TextStyle goldStyle = GoogleFonts.caveat(
    fontStyle: FontStyle.italic,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: goldColor
);

const Color goldColor = Color.fromRGBO(113, 84, 44, 1);