{ config, pkgs, lib, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
#    ../../common/cpu/amd 
#    ../../common/cpu/amd/pstate.nix 
#    ../../common/gpu/nvidia/prime.nix 
#    ../../common/gpu/nvidia/ampere 
#    ../../common/pc/laptop 
#    ../../common/pc/ssd 
  ];

  # ------------------------
  # Basic system settings
  # ------------------------
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Isle_of_Man";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  users.users.calum = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker"];
    packages = with pkgs; [ kdePackages.kate ];
  };

  environment.sessionVariables = {
    GSK_RENDERER = "gl";
  };
  # ------------------------
  # Bootloader
  # ------------------------
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1") [
      "hp-wmi"
    ];

    kernelParams = ["module_blacklist=amdgpu"];
  };

  # ------------------------
  # Display Manager
  # ------------------------
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      qt6.qtsvg
      qt6.qtmultimedia
      qt6.qtvirtualkeyboard
      qt6.qtdeclarative
    ];
    theme = "artemis-sddm1";
  };
  

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
  # ------------------------
  # Nvidia
  # ------------------------
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
#    prime = {
#      offload = {
#        enable = true;
#        enableOffloadCmd = true;
#      };
#      amdgpuBusId = "PCI:6:0:0";
#      nvidiaBusId = "PCI:1:0:0";
#    };

    modesetting.enable = true;
    
    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ------------------------
  # Hyprland
  # ------------------------
  programs.hyprland = {
    enable = true;
  };

  # ------------------------
  # Docker
  # ------------------------
  virtualisation.docker.enable = true;

  # ------------------------
  # Audio
  # ------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ------------------------
  # System packages
  # ------------------------
  environment.systemPackages = with pkgs; [
    #Productive
    git
    vim
    firefox
    kitty
    vscode
    obs-studio
    kdePackages.dolphin
    zip
    unzip
    feh

    #Nix Stuff
    waybar
    wofi
    mako
    wl-clipboard
    grim
    slurp
    hyprpaper
    swww
    matugen
    pywal
    wlogout
    walker
    
    #SDDM
    (pkgs.stdenv.mkDerivation {
      name = "artemis";

      src = ./artemis;

      installPhase = ''
        mkdir -p $out/share/sddm/themes/artemis-sddm1
        cp -r ./* $out/share/sddm/themes/artemis-sddm1/
      '';
    })

    #Not Productive
    spotify
    fastfetch
    cbonsai
    pipes
    btop
    peaclock
    discord
  ];

  # ------------------------
  # Fonts
  # ------------------------
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    jetbrains-mono
    font-awesome
    nerd-fonts.hack
    nerd-fonts._3270
  ];

  # ------------------------
  # Environment Variables
  # ------------------------
  nixpkgs.config.allowUnfree = true;

  # ------------------------
  # State version
  # ------------------------
  system.stateVersion = "25.05";
}
