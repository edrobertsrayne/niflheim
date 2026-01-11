_: {
  flake.modules.nixos.thor = {
    fileSystems = {
      "/export/media" = {
        device = "/mnt/storage/media";
        options = ["bind"];
      };
      "/export/downloads" = {
        device = "/mnt/ssd/downloads";
        options = ["bind"];
      };
    };

    services.nfs.server = {
      enable = true;
      exports = ''
        /export         192.168.68.0/22(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0) 100.64.0.0/10(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
        /export/media    192.168.68.0/22(insecure,rw,sync,no_subtree_check,nohide,fsid=1) 100.64.0.0/10(insecure,rw,sync,no_subtree_check,nohide,fsid=1)
        /export/downloads    192.168.68.0/22(insecure,rw,sync,no_subtree_check,nohide,fsid=2) 100.64.0.0/10(insecure,rw,sync,no_subtree_check,nohide,fsid=2)
      '';
    };

    services.rpcbind.enable = true;
    networking.firewall = {
      allowedTCPPorts = [111 2049 4000 4001 4002 20048];
      allowedUDPPorts = [111 2049 4000 4001 4002 20048];
    };
  };
}
