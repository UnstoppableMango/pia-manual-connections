{
  bashInteractive,
  busybox,
  curl,
  fetchFromGitHub,
  iproute2,
  jq,
  ncurses,
  lib,
  openvpn,
  stdenvNoCC,
  version,
  wireguard-tools,
  makeWrapper,
}:
let
  path = lib.makeBinPath [
    bashInteractive
    busybox
    curl
    iproute2
    jq
    ncurses
    openvpn
    wireguard-tools
  ];
in
stdenvNoCC.mkDerivation {
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
    install -Dm755 connect_to_openvpn_with_token.sh $out/bin/connect_to_openvpn_with_token
    install -Dm755 connect_to_wireguard_with_token.sh $out/bin/connect_to_wireguard_with_token
    install -Dm755 get_dip.sh $out/bin/get_dip
    install -Dm755 get_token.sh $out/bin/get_token
    install -Dm755 get_region.sh $out/bin/get_region
    install -Dm755 port_forwarding.sh $out/bin/port_forwarding
    install -Dm755 run_setup.sh $out/bin/run_setup
  '';

  postFixup = ''
    substituteInPlace $out/bin/connect_to_openvpn_with_token \
      --replace ./port_forwarding.sh $out/bin/port_forwarding \
      --replace ./get_token.sh $out/bin/get_token

    substituteInPlace $out/bin/connect_to_wireguard_with_token \
      --replace ./port_forwarding.sh $out/bin/port_forwarding \
      --replace ./get_token.sh $out/bin/get_token

    substituteInPlace $out/bin/get_region \
      --replace ./connect_to_openvpn_with_token.sh $out/bin/connect_to_openvpn_with_token \
      --replace ./connect_to_wireguard_with_token.sh $out/bin/connect_to_wireguard_with_token \
      --replace ./get_token.sh $out/bin/get_token

    substituteInPlace $out/bin/run_setup \
      --replace ./get_region.sh $out/bin/get_region \
      --replace ./get_token.sh $out/bin/get_token

    wrapProgram $out/bin/connect_to_openvpn_with_token --set PATH ${path}
    wrapProgram $out/bin/connect_to_wireguard_with_token --set PATH ${path}
    wrapProgram $out/bin/get_dip --set PATH ${path}
    wrapProgram $out/bin/get_token --set PATH ${path}
    wrapProgram $out/bin/get_region --set PATH ${path}
    wrapProgram $out/bin/port_forwarding --set PATH ${path}
    wrapProgram $out/bin/run_setup --set PATH ${path}
  '';

  meta = {
    description = "Manual connections for PIA";
    homepage = "https://github.com/pia-foss/manual-connections";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ UnstoppableMango ];
  };
}
