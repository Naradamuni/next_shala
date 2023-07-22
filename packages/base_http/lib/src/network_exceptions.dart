///A custom exception cass that supports a message and a prefix
class CustomException implements Exception {
  ///The constructor
  CustomException([this._message, this._prefix]);

  ///The exception message
  final _message;

  ///The exception prefix
  final _prefix;

  ///Conviience function to get exception message
  String toString() {
    return "$_prefix$_message";
  }
}

///Class excapsulatig an exception occuring from failure to fetch data
class FetchDataException extends CustomException {
  ///Constructor
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

///Class ecapsulating a exception occuring from a bad request that is sent
class BadRequestException extends CustomException {
  ///Constructor
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

///Class enncapsulating a exception occuring from a request that is unauthorized
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

///Class ecapsulating an exception occurig from a wrong input or para
class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

///Conviniece function that throws exception based on statusCode
///[statusCode] as int
dynamic checkStatusCode({required int statusCode, dynamic message}) {
  switch (statusCode) {
    case 200:
      return '';
    case 400:
      if (message != null && message is String) {
        throw BadRequestException(message);
      }
      throw BadRequestException('Something went wrong');
    case 401:
    case 403:
      throw UnauthorisedException('Unauthorized');
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${statusCode}');
  }
}
