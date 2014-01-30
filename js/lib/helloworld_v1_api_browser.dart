library helloworld_v1_api.browser;

import "package:google_oauth2_client/google_oauth2_browser.dart" as oauth;

import 'src/browser_client.dart';
import "helloworld_v1_api_client.dart";

/** Helloworld API v1. */
class Helloworld extends Client with BrowserClient {

  /** OAuth Scope2: View your email address */
  static const String USERINFO_EMAIL_SCOPE = "https://www.googleapis.com/auth/userinfo.email";

  final oauth.OAuth2 auth;

  Helloworld([oauth.OAuth2 this.auth]);
}
