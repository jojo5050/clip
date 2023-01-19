

import 'package:clip/Models/global_variables.dart';

mixin FormValidators {
  String? validateFullname(String? value){
    if(value!.isEmpty){return "field cannot be empty";

    }
  }

  String? usernameValidator(String? value){
    if(value!.isEmpty){return "field cannot be empty";

    }
  }

  String? validateBio(String? value){
    if(value!.isEmpty){
      return "field cannot be empty";
    }
  }

  String? emailValidator(String? value){
    if(value!.trim().isEmpty){
      return "Email cannot be empty";
    }
    else if (RegExp(
        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value) == false) {
      return 'Email is not valid';
    }
    return null;

  }

  String? passwordValidator(String? value){
    if(value!.trim().isEmpty){
      return "Passowrd cannot be empty";
    }
    else if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
        .hasMatch(value) ==
        false) {
      return 'The password entered is not valid';
    }
  }

  /*String? confirmPasswordValidator(String? value){
    if(value!.trim().isEmpty){
      return "Passowrd cannot be empty";
    }
    if(confirmPassField != passwordValidator(value)){
      return "Password did not match";
    }

    else if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
        .hasMatch(value) ==
        false) {
      return 'The password entered is not valid';
    }
  }*/

}