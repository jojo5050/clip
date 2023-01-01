
import 'package:flutter/cupertino.dart';

class FormModel {

  TextEditingController fullnameTextModel = TextEditingController();
  TextEditingController usernameTextModel = TextEditingController();
  TextEditingController bioTextModel = TextEditingController();

  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
}

