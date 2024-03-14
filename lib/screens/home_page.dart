import 'dart:convert';

import 'package:doc_appointment_app/components/appointment_card.dart';
import 'package:doc_appointment_app/components/doctor_card.dart';
import 'package:doc_appointment_app/providers/dio_provider.dart';
import 'package:doc_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    Map<String, dynamic> user = {};
     Map<String, dynamic> doctor = {};

  List<Map<String, dynamic >> medCat = [
    {
      'icon':FontAwesomeIcons.userDoctor,
      'category':'General'
    },
    {
      'icon':FontAwesomeIcons.heartPulse,
      'category':'Cardiology'
    },
    {
      'icon':FontAwesomeIcons.lungs,
      'category':'Respirations'
    },
    {
      'icon':FontAwesomeIcons.hand,
      'category':'Dermatology'
    },
    {
      'icon':FontAwesomeIcons.personPregnant,
      'category':'Gynecology'
    },
    {
      'icon':FontAwesomeIcons.teeth,
      'category':'Dental'
    }
  ];

  Future<void> getData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')?? '';

    if(token.isNotEmpty && token != ''){
      final response = await DioProvider().getUser(token);
      if(response != null){
        setState(() {
          user = json.decode(response); //convert into object..
          
          for(var doctorData in user['doctor']){ 
            //if there is appointment return for today, then pass doctor info...
            if(doctorData['appointments'] != null){
              doctor = doctorData;
              print(doctor);
            }
          }
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: user.isEmpty ? 
      const Center(
        child: CircularProgressIndicator(),
      )
      : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user['name'], 
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/sophie.jpeg'),
                        ),
                      )
                    ],
                  ),
                  Config.spaceSmall,
                   Text(
                    user['type'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Config.spaceSmall,
                  SizedBox(
                    height: Config.heightSize * 0.05,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List<Widget>.generate(medCat.length, (index){
                        return Card(
                          margin: const EdgeInsets.only(right: 20),
                          color: Config.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  medCat[index]['icon'],
                                  color:  Colors.white,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  medCat[index]['category'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Config.spaceSmall,
                  const Text(
                    'Appointment Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  Config.spaceSmall,
                  doctor.isNotEmpty ?
                  AppointmentCard(doctor: doctor, color: Config.primaryColor,)
                  :Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Padding(padding: EdgeInsets.all(20),
                      child: Text(
                        'No Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ),
                    ),
                  ),
                  Config.spaceSmall,
                  const Text(
                    'Top Doctors',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  Config.spaceSmall,
                  Column(
                    children: List.generate(user['doctor'].length, (index){
                      return  DoctorCard(
                        route: 'doc_details',
                        doctor: user['doctor'][index],
                      );
                    }),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
