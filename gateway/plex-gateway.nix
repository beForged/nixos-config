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
        proxy_pass 100.111.74.101:32400;
        proxy_timeout 86400s;
        proxy_connect_timeout 5s;
      }
    '';
  };
}
