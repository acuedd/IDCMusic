
enum ViewState{
  idle, busy, empty, error, unAuthorized,
}

enum ErrorType{
  defaultError, 
  networkError,
}

class ViewStateError{
  ErrorType errorType;
  String message;
  String errorMessage;

  ViewStateError(this.errorType, { this.message, this.errorMessage }){
    errorType ??= ErrorType.defaultError;
    message ??= errorMessage;
  }

  get isNetworkError => errorType == ErrorType.networkError; 

  @override
  String toString() {
    return 'ViewStateError{ errorType: $errorType, message: $message, errorMessage: $errorMessage }';
  }
}

enum ConnectivityStatus { WiFi, Cellular, Offline }
