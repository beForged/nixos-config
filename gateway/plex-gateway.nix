{
  config,
  pkgs,
  ...
}: {
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
        plex = {
          address = ":32400";
        };
        traefik = {
          address = ":8080";
        };
      };

      api = {
        dashboard = true;
        insecure = true;
      };

      metrics.prometheus = {
        entryPoint = "traefik";
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          plex = {
            rule = "Host(`gateway.tail097e5.ts.net`) || PathPrefix(`/`)";
            entryPoints = ["plex" "web"];
            service = "plex-backend";
          };
        };
        services = {
          plex-backend = {
            loadBalancer.servers = [
              {
                url = "http://100.111.74.101:32400";
              }
            ];
            loadBalancer.responseForwarding.flushInterval = "100ms";
            loadBalancer.healthCheck = {
              path = "/identity";
              interval = "30s";
              timeout = "5s";
            };
          };
        };
      };
    };
  };
}
