library helloworld_v1_api.console;

import "package:google_oauth2_client/google_oauth2_console.dart" as oauth2;

import 'src/console_client.dart';

import "helloworld_v1_api_client.dart";

/** Helloworld API v1. */
class Helloworld extends Client with ConsoleClient {

  /** OAuth Scope2: View your email address */
  static const String USERINFO_EMAIL_SCOPE = "https://www.googleapis.com/auth/userinfo.email";

  final oauth2.OAuth2Console auth;

  Helloworld([oauth2.OAuth2Console this.auth]);
}
