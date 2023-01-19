
import 'package:clip/Utils/authResultStatus.dart';

class AuthExceptionHandler{

  static handleException(e){

    var mssgStatus;
    switch(e.code){
      case "email-already-in-use":
       mssgStatus  = AuthResultStatus.emailAlreadyExist;
       break;

      default:
       mssgStatus = AuthResultStatus.undefined;
    }

    return mssgStatus;
  }

  static generateExceptionMssg(exceptionCode){

    String errorMsg;
    switch(exceptionCode){

      case AuthResultStatus.emailAlreadyExist:
        errorMsg = "The Email Entered Already Exist";
        break;

      default:
        errorMsg = "An Undefined Error has occurred";
    }

    return errorMsg;

  }
}