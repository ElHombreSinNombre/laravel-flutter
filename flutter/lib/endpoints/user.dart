import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map/models/user.dart';

class UserService {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };

  Future<String> login(Map<String, dynamic> form) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/user/login');
      http.Response response =
          await http.post(url, headers: headers, body: form);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'];
      } else if (response.statusCode == 401) {
        return '${response.statusCode}';
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in login');
    }
  }

  Future<List<UserModel>> getAll() async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/users/all');
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => UserModel.fromJson(data)).toList();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in fetch users');
    }
  }

  Future<String> create(Map<String, dynamic> form) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/users/create');
      http.Response response =
          await http.post(url, body: form, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'];
      } else if (response.statusCode == 409) {
        return '${response.statusCode}';
      } else if (response.statusCode == 422) {
        return '${response.statusCode}';
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in create user');
    }
  }

  Future<UserModel> edit(int? id) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/users/edit/$id');
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return UserModel.fromJson(jsonResponse);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in edit user');
    }
  }

  Future<String> update(int? id, Map<String, dynamic> form) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/users/update/$id');
      http.Response response =
          await http.patch(url, body: form, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'];
      } else if (response.statusCode == 409) {
        return '${response.statusCode}';
      } else if (response.statusCode == 422) {
        return '${response.statusCode}';
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in update user');
    }
  }

  Future<String> delete(int id) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:80/users/delete/$id');
      http.Response response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'];
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed in delete user');
    }
  }
}
