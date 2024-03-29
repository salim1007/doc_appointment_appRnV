import 'package:doc_appointment_app/screens/appointment_page.dart';
import 'package:doc_appointment_app/screens/fav_page.dart';
import 'package:doc_appointment_app/screens/home_page.dart';
import 'package:doc_appointment_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value){
          setState(() {
            currentPage = value;
          });
        }),
        children: const [
          HomePage(),
          FavPage(),
          AppointmentPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page){
          setState(() {
            currentPage = page;
            _page.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon:FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Favourite'
          ),
           BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointments'
          ),
           BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}
