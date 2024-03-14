import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier{
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when logging in..
  Map<String, dynamic> appointment = {}; //update upcoming appointment when logging in....
  List<Map<String, dynamic>> favDoc = []; //get latest favourite doctor.....
  List<dynamic> _fav = []; //get all fav doctor id in list...

  bool get isLogin{
    return _isLogin;
  }

  List<dynamic> get getFav{
    return _fav;
  }

  Map<String, dynamic> get getUser{
    return user;
  }

  Map<String, dynamic> get getAppointment{
    return appointment;
  }

// update latest favourite list and notify all widgets.....
  void setFavList(List<dynamic> list){// list of doctor id's...
    _fav = list;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getFavDoc{
    favDoc.clear();

    for(var num in _fav){
      for(var doc in user['doctor']){
        if(num == doc['doc_id']){
          favDoc.add(doc);
        }
      }
    }
    return favDoc;
  }


  void loginSuccess(Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo){
    _isLogin = true;
    user = userData;
    appointment = appointmentInfo;
    _fav = json.decode(user['details']['fav']);
    notifyListeners();
  }
}