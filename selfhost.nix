{
  config,
  pkgs,
  ...
}: {
  # run git server to serve obsidian vault ++
  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";
    settings = {
      server = {
        DOMAIN = "nixos.tail097e5.ts.net";
        ROOT_URL = "http://nixos.tail097e5.ts.net/forgejo";
        HTTP_PORT = 3000;
        SSH_PORT = 2222;
      };
    };
  };

  # create git user for forgejo
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/forgejo";
    shell = pkgs.bash;
  };

  users.groups.git = {};
  # mount tempfile for forgejo
  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo/custom 0755 git git - -"
  ];

  # --------------------------

  services.adguardhome = {
    enable = true;
    openFirewall = false;
    port = 3001;
    settings = {
      #http.address = "127.0.0.1:9001";
      dns.bind_host = "192.168.86.20";
      dns.port = 3005;
      schema_version = 20;
    };
  };

  # --------------------------

  # enable jellyfin
  services.jellyfin = {
    enable = true;
    user = "scarlet";
  };

  # --------------------------

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  # --------------------------

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3333;
        domain = "nixos.tail097e5.ts.net";
        root_url = "http://nixos.tail097e5.ts.net/grafana";
        serve_from_sub_path = true;
      };
    };
  };

  # --------------------------

  #postgresql
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    authentication = ''
      local all all peer
    '';
  };

  # --------------------------

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
        traefik = {
          address = ":8080"; # Enable dashboard endpoint
        };
      };

      api = {
        dashboard = true;
        insecure = true;
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
          homepage = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/`)";
            entryPoints = ["web"];
            service = "homepage";
          };
          forgejo = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/forgejo`)";
            service = "forgejo";
            entryPoints = ["web"];
            middlewares = ["strip-forgejo-prefix"];
          };
          grafana = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/grafana`)";
            service = "grafana";
            entryPoints = ["web"];
          };
          jellyfin = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/jellyfin`)";
            service = "jellyfin";
            entryPoints = ["web"];
            middlewares = ["strip-jellyfin-prefix"];
          };
          traefik-dash = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/traefik`)";
            service = "traefik";
            entryPoints = ["web"];
            middlewares = ["strip-traefik-dash-prefix"];
          };
        };
        middlewares = {
          strip-forgejo-prefix = {
            stripPrefix.prefixes = ["/forgejo"];
          };
          strip-jellyfin-prefix = {
            stripPrefix.prefixes = ["/jellyfin"];
          };
          strip-traefik-dash-prefix = {
            stripPrefix.prefixes = ["/traefik"];
          };
        };
        services = {
          homepage = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:9100";
              }
            ];
          };
          forgejo = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:3000";
              }
            ];
          };
          grafana = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:3333";
              }
            ];
          };
          jellyfin = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:8096";
              }
            ];
          };
          traefik = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:8080";
              }
            ];
          };
        };
      };
    };
  };
}
