{
  buildEnv,
  curl,
  fetchFromGitHub,
  iproute2,
  jq,
  ncurses,
  lib,
  stdenv,
  version,
  wireguard-tools,
  makeWrapper,
}:
let
  packageScript =
    name:
    stdenv.mkDerivation {
      pname = "pia-manual-connections";
      inherit version;

      nativeBuildInputs = [ makeWrapper ];

      src = fetchFromGitHub {
        owner = "pia-foss";
        repo = "manual-connections";
        rev = "a1412dbe2ca41edbb79c766bc475335cb6cb13ad";
        sha256 = "sha256-SaCxirr/LF2a8PdTTZY98aEYVCYC0RxfT1XpWs4x7f0=";
      };

      patches = [
        ../patches/001-echo-token.patch
        ../patches/002-wireguard-script-args.patch
      ];

      installPhase = ''
        install -Dm755 ${name}.sh $out/bin/${name}
      '';

      postFixup = ''
        wrapProgram $out/bin/${name} --set PATH ${
          lib.makeBinPath [
            curl
            iproute2
            jq
            ncurses
            wireguard-tools
          ]
        }
      '';

      meta = {
        description = "Manual connections for PIA";
        homepage = "https://github.com/pia-foss/manual-connections";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ UnstoppableMango ];
      };
    };
in
buildEnv {
  name = "pia-manual-connections";
  paths = [
    (packageScript "connect_to_openvpn_with_token")
    (packageScript "connect_to_wireguard_with_token")
    (packageScript "get_region")
    (packageScript "get_token")
    (packageScript "port_forwarding")
    (packageScript "run_setup")
  ];
}
