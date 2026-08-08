{
  config,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedOptimisation = true;

    virtualHosts."plex" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "0.0.0.0";
          port = 32400;
        }
      ];

      locations."/" = {
        proxyPass = "http://100.111.74.101:32400";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_request_buffering off;
          proxy_read_timeout 86400s;
          proxy_send_timeout 86400s;
        '';
      };
    };
  };
}
