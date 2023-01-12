enum Environement {
  local(
      keycloack: Keycloack(
          issuer:
              "https://re7.abo.canalplustelecom.com/dev/auth/realms/abonne-recette",
          clientid: "canalbox-apps"),
      pfs: Pfs(webapi: WebAPI(host: "http://10.105.20.164/webApi_PFS"))),
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
      pfs:
          Pfs(webapi: WebAPI(host: "re7.oss.canalplustelecom.com/webApi_PFS"))),
  production(
      keycloack: Keycloack(
          issuer:
              "https://abo.canalplustelecom.com/dev/auth/realms/abonne-recette",
          clientid: "canalbox-apps"),
      pfs: Pfs(webapi: WebAPI(host: "oss.canalplustelecom.com//webApi_PFS")));

  final Pfs pfs;
  final Keycloack keycloack;
  const Environement({required this.pfs, required this.keycloack});
}

class ApplicationConfiguration {
  static Environement? environement;
  /*factory ApplicationConfiguration._local() => ApplicationConfiguration(Environement.local);
  factory ApplicationConfiguration.development() => ApplicationConfiguration(Environement.development);
  factory ApplicationConfiguration.recette() => ApplicationConfiguration(Environement.recette);
  factory ApplicationConfiguration.production() => ApplicationConfiguration(Environement.production);*/

  //static final ApplicationConfiguration? instance = ;
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
}
