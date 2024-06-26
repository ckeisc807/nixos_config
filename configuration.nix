# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
			./users/ckeisc807.nix
			./users/ckefgisc.nix
			./cachix.nix
		];
# Bootloader.
#boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.grub.devices = [ "nodev" ];
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.useOSProber = true;
	boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

	networking.hostName = "807nix"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
	networking.networkmanager.enable = true;

# Set your time zone.
	time.timeZone = "Asia/Taipei";

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-chewing
				fcitx5-mozc
				fcitx5-gtk
				fcitx5-chinese-addons
#      fcitx5-breeze
				fcitx5-configtool
#      fcitx5-gt
		];
	};
	services.xserver.desktopManager.runXdgAutostartIfNone = true;

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

# power management for laptop
	services.auto-cpufreq.enable = true;
	services.auto-cpufreq.settings = {
		battery = {
			governor = "powersave";
			turbo = "never";
		};
		charger = {
			governor = "performance";
			turbo = "auto";
		};
	};

# Enable the X11 windowing system.
	services.xserver.enable = true;


# Enable the KDE Plasma Desktop Environment.
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;


# GNOME desktop intergration
	qt = {
		enable = true;
		platformTheme = "gnome";
		style = "adwaita-dark";
	};

# Configure keymap in X11
	services.xserver = {
		layout = "us";
		xkbVariant = "";
	};

# Enable CUPS to print documents.
	services.printing.enable = true;

# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
# If you want to use JACK applications, uncomment this
		jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
	};

# Enable touchpad support (enabled default in most desktopManager).
	services.xserver.libinput = {
		enable = true;
		touchpad = {
			naturalScrolling = true;
			tapping = true;
			disableWhileTyping = false;
			horizontalScrolling = true;
		};
	};
	services.xserver.modules = [ pkgs.xf86_input_wacom ];
	services.xserver.wacom.enable = true;

# Enable touch screen


# hotkeys
	services.actkbd = {
		enable = true;
		bindings = [
		];
	};

	hardware.sensor.iio.enable = true;
# nvidiagpu
	/*  katago.override = {
		backend = "cuda";
		cudnn = cudnn_cudatoolkit_10_2;
		cudatoolkit = cudatoolkit_10_2;
		stdev = gccc8Stdev;
		};*/
# Enable OpenGL
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

# Load nvidia driver for Xorg and Wayland
	services.xserver.videoDrivers = ["nvidia" "intel"]; # or "nvidiaLegacy470 etc.

		hardware.nvidia = {
			prime = {
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:43:0:0";
			};
# Modesetting is required.
			modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
# of just the bare essentials.
			powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
			powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of
# supported GPUs is at:
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
# Only available from driver 515.43.04+
# Currently alpha-quality/buggy, so false is currently the recommended setting.
			open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
			nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
			package = config.boot.kernelPackages.nvidiaPackages.stable;
		};
### endof gpu

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.cudaSupport = true;
	nixpkgs.config.allowUnsupportedSystem = true;

# List packages installed in system profile. To search, run:
	environment = {
		sessionVariables = {
#LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
		};
	};
# $ nix search wget
	environment.plasma5.excludePackages = with pkgs.libsForQt5; [
		plasma-browser-integration
			oxygen
			kwallet
			kwallet-pam
			kwalletmanager
	];


	environment.systemPackages = with pkgs; [
		auto-cpufreq
			nano# Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
			neofetch
			lightdm-mobile-greeter # touch screen
			busybox
			lshw
			gperftools
#	nvidia-vaapi-driver
			cudaPackages.cudatoolkit
			cudaPackages.cuda_cudart
			cudaPackages.cudnn
			cudaPackages.cuda_nvcc
			glxinfo
			glibc
			libgcc
			cmake
			gnumake
			gcc
			gdb
			htop-vim
			git
			lazygit
			tree
			gparted
			tmux
			wget
			rustc
			cargo
#wayland
			(pkgs.waybar.overrideAttrs (oldAttrs: {
										mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
										}))
	eww
		dunst
		libnotify
		hyprpaper
#	swaybg
#	wpaperd
#	mpvpater
		swww
# terminal
		kitty
#	alacritty
#	wezterm
#
		rofi-wayland
##
		(import ./vim.nix)
		(python310.withPackages(ps: with ps; [ pip discordpy requests python-dotenv ]))
		(vscode-with-extensions.override {
		 vscode = vscodium;
		 vscodeExtensions = with vscode-extensions; [
		 vscodevim.vim
		 rust-lang.rust-analyzer
		 github.copilot
		 johnpapa.vscode-peacock
		 ms-vscode.cpptools
		 ms-vscode.makefile-tools
		 ms-vscode.hexeditor
		 ms-vscode-remote.remote-ssh
		 ms-vscode.cmake-tools
		 esbenp.prettier-vscode
		 ];
		 })
#*/
	];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
	};

#hyprland
	programs.hyprland = {
		enable = true;
		enableNvidiaPatches = true;
		xwayland.enable = true;
	};

	environment.sessionVariables = {
		WLR_NO_HARDWARE_CURSORS = "1";
		NIXOS_OZONE_WL = "1";
	};

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};


# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

}
