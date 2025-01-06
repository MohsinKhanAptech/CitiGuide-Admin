import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final connectionChecker = InternetConnectionChecker.instance;
