{ config, pkgs, ... }:

let
  db_user = "split";
  db_pass = "split_ventures";
  documize_db_name = "documize";
  hydra_db_name = "hydra";
in
{
  services.postgresql = {
    enable = true;
    dataDir = "/var/lib/postgresql/11";
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE ${db_user} WITH LOGIN PASSWORD '${db_pass}' CREATEDB;
      CREATE DATABASE ${hydra_db_name};
      GRANT ALL PRIVILEGES ON DATABASE ${hydra_db_name} TO ${db_user};
      CREATE DATABASE ${documize_db_name};
      GRANT ALL PRIVILEGES ON DATABASE ${documize_db_name} TO ${db_user};
    '';
  };

  services.hydra = {
    dbi = "dbi:Pg:dbname=${hydra_db_name};user=${db_user};";
    enable = true;
    hydraURL = "split.local"; # externally visible URL
    notificationSender = "marijan.petricevic@icloud.com"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [ ];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
    port = 3000;
  };

  services.documize = {
    enable = false;
    port = 5001;
    db = "host=localhost port=${toString config.services.postgresql.port} dbname=${documize_db_name} user=${db_user} password=${db_pass} sslmode=disable";
  };

  networking.firewall.allowedTCPPorts = [ config.services.documize.port config.services.hydra.port ];
}
