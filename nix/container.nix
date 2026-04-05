{
  version,
  piaManualConnections,
  dockerTools,
}:
dockerTools.streamLayeredImage {
  name = "pia-manual-connections";
  tag = version;

  contents = piaManualConnections;

  config = {
    Cmd = [ "/bin/run_setup" ];
    Volumes = {
      "/opt/piavpn-manual" = { };
    };
  };
}
