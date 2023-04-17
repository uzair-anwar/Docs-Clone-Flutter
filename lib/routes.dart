import 'package:docs_clone/screens/home_screen.dart';
import 'package:docs_clone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
    routes: {'/': (router) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(
    routes: {'/': (router) => const MaterialPage(child: HomeScreen())});
