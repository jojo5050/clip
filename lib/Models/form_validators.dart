

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

}