import 'dart:convert';
import 'package:docs_clone/models/user_model.dart';
import 'package:docs_clone/services/localstorage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../models/error_model.dart';
import '../constants.dart';

final authServiceProvider = Provider((ref) => AuthService(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageService: LocalStorageService()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthService {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageService _localStorageService;

  AuthService(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageService localStorageService})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageService = localStorageService;

  Future<ErrorModel> signInwithGoogle() async {
    ErrorModel error = ErrorModel(error: "Some unexpected error", data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
            email: user.email,
            name: user.displayName ?? '',
            profilePic: user.photoUrl ?? '',
            uid: "",
            token: "");
        var res = await _client.post(Uri.parse("$host/auth/signup"),
            body: userAccount.toJson(),
            headers: {'Content-Type': "application/json; charset=UTF-8"});
        switch (res.statusCode) {
          case 200:
            final newUser = userAccount.copyWith(
                uid: jsonDecode(res.body)['user']['_id'],
                token: jsonDecode(res.body)['token']);
            error = ErrorModel(error: "null", data: newUser);
            _localStorageService.setToken(newUser.token);
            break;
          default:
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(error: "Some unexpected error", data: null);
    try {
      String? token = await _localStorageService.getToken();
      if (token != null) {
        var res = await _client.post(Uri.parse("$host/auth/getUser"), headers: {
          'Content-Type': "application/json; charset=UTF-8",
          'Bearer': token
        });
        switch (res.statusCode) {
          case 200:
            final newUser =
                UserModel.fromJson(jsonEncode(jsonDecode(res.body)['user']))
                    .copyWith(token: token);
            error = ErrorModel(error: "null", data: newUser);
            _localStorageService.setToken(newUser.token);
            break;
          default:
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  signOut() async {
    await _googleSignIn.signOut();
    _localStorageService.setToken('');
  }
}
