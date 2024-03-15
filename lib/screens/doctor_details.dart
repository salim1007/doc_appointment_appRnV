import 'package:dio/dio.dart';
import 'package:doc_appointment_app/components/button.dart';
import 'package:doc_appointment_app/models/auth_model.dart';
import 'package:doc_appointment_app/providers/dio_provider.dart';
import 'package:doc_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    // get arguments passed from doctor card.....
    final doctorDetails = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(
          Icons.arrow_back_ios,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final list =
                    Provider.of<AuthModel>(context, listen: false).getFav;

                //if doc id already exists, on tapping you remove it....
                if (list.contains(doctorDetails['doc_id'])) {
                  list.removeWhere((id) => id == doctorDetails['doc_id']);
                } else {
                  //else, add it to list
                  list.add(doctorDetails['doc_id']);
                }

                //update the list and notify all widgets...
                Provider.of<AuthModel>(context, listen: false).setFavList(list);

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final token = prefs.getString('token') ?? '';

                if (token.isNotEmpty && token != '') {
                  final response = await DioProvider().storeFavDoc(token, list);
                  if (response == 200) {
                    setState(() {
                      isFav = !isFav;
                    });
                  }
                }
              },
              icon: FaIcon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutDoctor(
              doctor: doctorDetails,
            ),
            DetailBody(
              doctor: doctorDetails,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Button(
                  width: double.infinity,
                  title: 'Book Appointment',
                  onPressed: () {
                    // pass doctor id for booking process...
                    Navigator.of(context).pushNamed('booking_page',
                        arguments: {'doctor_id': doctorDetails['doc_id']});
                  },
                  disable: false),
            )
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key, required this.doctor});

  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
                "http://127.0.0.1:8000${doctor['doctor_profile']}"),
            backgroundColor: Colors.white,
          ),
          Config.spaceSmall,
          Text(
            "Dr ${doctor['doctor_name']}",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'MBBS(International Medical University, Malaysia), MRCP (Royal college of Physicians, United Kingdom)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Sawak General Hospital',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.doctor});

  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DoctorInfo(
            patients: doctor['patients'],
            exp: doctor['experience'],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'About Doctor',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Dr. ${doctor['doctor_name']} is an experienced ${doctor['category']} specialist  at Sarawak, graduated since 2008, and completed his/her training at Sungai Buloh general Hospital.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key, required this.patients, required this.exp});

  final int patients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Patients',
          value: '$patients',
        ),
        const SizedBox(
          width: 15.0,
        ),
        InfoCard(
          label: 'Experience',
          value: '$exp',
        ),
        const SizedBox(
          width: 15.0,
        ),
        const InfoCard(
          label: 'Rating',
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
