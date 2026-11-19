{
  config,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;

    streamConfig = ''
      server {
        listen 32400;
        proxy_pass nixos.gecko-egret.ts.net:32400;
        proxy_timeout 86400s;
        proxy_connect_timeout 5s;
      }
    '';
  };
}
