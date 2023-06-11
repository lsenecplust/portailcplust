enum Environement {
  local(
      keycloack: Keycloack(
          issuer:
              "https://lemur-6.cloud-iam.com/auth/realms/portailcplustelecomtest",
          clientid: "canalbox-apps"),
      pfs: Pfs(webapi: WebAPI(host: "https://192.168.0.14:5001"))),
  development(
      keycloack: Keycloack(
          issuer:
              "https://re7.abo.canalplustelecom.com/dev/auth/realms/abonne-recette",
          clientid: "canalbox-apps"),
      pfs: Pfs(webapi: WebAPI(host: "http://10.105.20.164/webApi_PFS"))),
  recette(
      keycloack: Keycloack(
          issuer:
              "https://re7.abo.canalplustelecom.com/dev/auth/realms/abonne-recette",
          clientid: "canalbox-apps"),
      pfs: Pfs(
          webapi: WebAPI(host: "https://re7.abo.canalplustelecom.com/pfs"))),
  production(
      keycloack: Keycloack(
          issuer:
              "https://abo.canalplustelecom.com/dev/auth/realms/abonne-recette",
          clientid: "canalbox-apps"),
      pfs: Pfs(webapi: WebAPI(host: "https://abo.canalplustelecom.com/pfs")));

  final Pfs pfs;
  final Keycloack keycloack;
  const Environement({required this.pfs, required this.keycloack});
}

class ApplicationConfiguration {
  static Environement? environement;
  static Pfs get pfs => environement!.pfs;
  static Keycloack get keycloack => environement!.keycloack;
  static setlocal() {
    environement = Environement.local;
  }

  static setdevelopment() {
    environement = Environement.development;
  }

  static setrecette() {
    environement = Environement.recette;
  }

  static setproduction() {
    environement = Environement.production;
  }
}

class Pfs {
  final WebAPI webapi;
  const Pfs({
    required this.webapi,
  });
}

class WebAPI {
  final String host;
  const WebAPI({
    required this.host,
  });
}

class Keycloack {
  final String issuer;
  final String clientid;
  const Keycloack({
    required this.issuer,
    required this.clientid,
  });
  Uri get authorizationEndpoint =>
      Uri.parse("$issuer/protocol/openid-connect/auth");
  Uri get tokenEndpoint => Uri.parse("$issuer/protocol/openid-connect/token");
}
