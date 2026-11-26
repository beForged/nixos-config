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
        DOMAIN = "nixos.gecko-egret.ts.net";
        ROOT_URL = "http://nixos.gecko-egret.ts.net/forgejo";
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
  systemd.tmpfiles.rules = [
    # mount tempfile for forgejo
    "d /var/lib/forgejo/custom 0755 git git - -"
    "a+ /home/scarlet - - - - u:jellyfin:--x,m::--x"
  ];

  # --------------------------

  #  services.adguardhome = {
  #    enable = true;
  #    openFirewall = false;
  #    port = 3001;
  #    settings = {
  #      #http.address = "127.0.0.1:9001";
  #      dns.bind_host = "192.168.86.20";
  #      dns.port = 3005;
  #      schema_version = 20;
  #    };
  #  };

  # --------------------------

  services.actual = {
    enable = true;
    settings = {
      port = 5006;
    };
  };

  # --------------------------

  # enable jellyfin
  services.jellyfin = {
    enable = true;
  };

  # --------------------------

  # plex - accessible via tailscale and OCI gateway
  services.plex = {
    enable = true;
    openFirewall = false;
    dataDir = "/var/lib/plex";
  };

  # allow plex on tailscale interface only (OCI gateway connects over tailscale)
  # moved to consolidate on config.nix
  # networking.firewall.interfaces.tailscale0.allowedTCPPorts = [32400];

  # --------------------------

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  # --------------------------

  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "random-string";
      server = {
        http_addr = "127.0.0.1";
        http_port = 3333;
        domain = "nixos.gecko-egret.ts.net";
        root_url = "http://nixos.gecko-egret.ts.net/grafana";
        serve_from_sub_path = true;
      };
    };
  };

  # --------------------------

  # lastfm homepage, served on / by traefik below
  services.lastfmanalysis = {
    enable = true;
    port = 9100;
    # run as me so /push and /pull can use ~/vault/vault and my git/ssh keys
    user = "scarlet";
    group = "users";
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
          # dashboard endpoint, insecure api so keep it on localhost only (no router)
          address = "127.0.0.1:8080";
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
          homepage = {
            rule = "Host(`nixos.gecko-egret.ts.net`) && PathPrefix(`/`)";
            entryPoints = ["web"];
            service = "homepage";
          };
          forgejo = {
            rule = "Host(`nixos.gecko-egret.ts.net`) && PathPrefix(`/forgejo`)";
            service = "forgejo";
            entryPoints = ["web"];
            middlewares = ["strip-forgejo-prefix"];
          };
          grafana = {
            rule = "Host(`nixos.gecko-egret.ts.net`) && PathPrefix(`/grafana`)";
            service = "grafana";
            entryPoints = ["web"];
          };
          jellyfin = {
            rule = "Host(`nixos.gecko-egret.ts.net`) && PathPrefix(`/jellyfin`)";
            service = "jellyfin";
            entryPoints = ["web"];
            # no stripPrefix here: jellyfin is configured with
            # HttpRoot=jellyfin (in /var/lib/jellyfin/config/jellyfin.config.xml)
            # and serves under /jellyfin itself. Stripping the prefix causes
            # an infinite redirect loop.
          };
          actual-budget = {
            rule = "Host(`nixos.gecko-egret.ts.net`) && PathPrefix(`/money`)";
            service = "actual";
            entryPoints = ["web"];
            middlewares = ["strip-actual-prefix"];
          };
        };
        middlewares = {
          strip-forgejo-prefix = {
            stripPrefix.prefixes = ["/forgejo"];
          };
          strip-actual-prefix = {
            stripPrefix.prefixes = ["/money"];
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
          actual = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:5006";
              }
            ];
          };
        };
      };
    };
  };
}
