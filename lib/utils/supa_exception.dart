class SupaException implements Exception {

  final String message;

  SupaException([this.message = 'Something went wrong, please try again or contact support']);

}