{ ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/tater/music"; 
    playlistDirectory = "/home/tater/music/playlists"; 
    dataDir = "/home/tater/music/data";
    network= {
      startWhenNeeded = true; #might be uneeded
      port = 45100;
      listenAddress = "fe80::674e:3443:cba8:8e35";#might need the port number taped on the end with a :
    };
  };
  services.mpd-mpris = { enable = true;
    mpd = {
      network = "tcp";
      host = "fe80::674e:3443:cba8:8e35";
      port = 45100;
    };
  }; 
  programs.ncmpcpp.enable = true;
} #[fe80::674e:3443:cba8:8e35]  //  192.168.0.56/255
