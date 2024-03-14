import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider{
  Future<dynamic> getToken(String email, String password) async{
    try{
      var response = await Dio().post('http://127.0.0.1:8000/api/login', data: {'email':email, 'password':password});
      if(response.statusCode == 200 && response.data != ''){
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      }else{
        return false;
      }
    }catch(error){
      print('Error occurred: $error'); // Optionally print the error
      return false;
    }
  }

  Future<dynamic> getUser(String token) async{
    try{
      var user = await Dio().get('http://127.0.0.1:8000/api/user', options: Options(headers: {'Authorization': 'Bearer $token'}));
      if(user.statusCode == 200 && user.data !=''){
        return json.encode(user.data);  //convert to string......
      }else{
        return 'Error';
      }
    }catch(error){
      print('Error occurred: $error'); // Optionally print the error
      return false;
    }
  }

  Future<dynamic> register(String username, String email, String password) async{
    try{
      var user = await Dio().post('http://127.0.0.1:8000/api/register', data: {'name':username, 'email':email, 'password':password});
      if(user.statusCode == 201 && user.data !=''){
        return true;
      }else{
        return false;
      }
    }catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace: $stacktrace');
      return false;
    }
  }

  Future<dynamic> bookAppointment(String date, String day, String time, int doctor, String token) async{
    try{
      var response = await Dio().post('http://127.0.0.1:8000/api/book',
     data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
     options: Options(headers: {'Authorization': 'Bearer $token'}));

     if(response.statusCode == 200 && response.data !=''){
      return response.statusCode;
     }else{
      return 'Error';
     }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> getAppointments(String token) async{
    try{
      var response = await Dio().get('http://127.0.0.1:8000/api/appointments',
     options: Options(headers: {'Authorization': 'Bearer $token'}));

     if(response.statusCode == 200 && response.data !=''){
      return json.encode(response.data);
     }else{
      return 'Error';
     }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> storeReviews(String reviews, double ratings, int id, int doctor, String token) async{
    try{
      var response = await Dio().post('http://127.0.0.1:8000/api/reviews',
     data: {'reviews': reviews, 'ratings': ratings, 'doctor_id': doctor, 'appointment_id': id},
     options: Options(headers: {'Authorization': 'Bearer $token'}));

     if(response.statusCode == 200 && response.data !=''){
      return response.statusCode;
     }else{
      return 'Error';
     }
    }catch(error){
      return error;
    }
  }
}