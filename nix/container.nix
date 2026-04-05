{
  stdenvNoCC,
  dockerTools,
  lib,
  piaManualConnections,
  version,
}:
let
  entrypoint = stdenvNoCC.mkDerivation {
    name = "entrypoint";
    src = lib.cleanSource ../.;
    dontBuild = true;

    installPhase = ''
      install -Dm755 entrypoint.sh $out/bin/entrypoint
    '';

    postFixup = ''
      substituteInPlace $out/bin/entrypoint \
        --replace ./run_setup.sh ${piaManualConnections}/bin/run_setup
    '';
  };
in
dockerTools.streamLayeredImage {
  name = "pia-manual-connections";
  tag = version;

  contents = [
    piaManualConnections
    entrypoint
  ];

  config = {
    Cmd = [ "/bin/entrypoint" ];
    Volumes = {
      "/opt/piavpn-manual" = { };
    };
  };
}
