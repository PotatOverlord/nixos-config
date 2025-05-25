{
  disko.devices = {
    disk = {
      CHANGEME!!!!!!!!!! = {
        type = "gpt";
	partitions = {
	  ESP = {
	    label = "boot";
	    size = "512M";
	    type = "EF00";
	    content = {
	      type = "filesystem";
	      format = "vfat";
	      mountpoint = "/boot";
	      mountOptions = [ "umask=0077" ];
	    };
	  };
	  luks = {
            size = "100%";
	    label = "luks";
	    content = {
	      type = "luks";
	      name = "cryptroot";
	      extraOpenArgs = [
	        "--allow-discards"
		"--perf_no_read_workqueue"
		"--perf_no_write_workqueue"
	      ];
              
	      settings = {crypttabExtraOpts = ["tpm2-device=auto" "tpm2-pcrs=7"];};
	      content = {
	        type = "btfrs";
		extraArgs = ["-L" "nixos" "-f"];
		subvolumes = {
		  "/root" = {
		    mountpoint = "/";
		    mountOptions = ["subvol=root" "compress=zstd" "noatime"];
		  };
		  "/home" = {
		    mountpoint = "/home";
		    mountOptions = ["subvol=home" "compress=zstd" "noatime"];
		  };
		  "/persist" = {
		    mountpoint = "/persist";
		    mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
		  };
		  "/log" = {
		    mountpoint = "/var/log";
		    mountOptions = ["subvol=log" "compress=zstd" "noatime"];
		  };
		  "/swap" = {
		    mountpoint = "/swap";
		    swap.swapfile.size = "16G";
		  };
		};
	      };
	    };
	  };
	};
      };
    };
  };
  filesystems."/persist".neededForBoot = true;
  filesystems."/var/log".neededForBoot = true;
}
