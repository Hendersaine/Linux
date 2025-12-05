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
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  # ------------------------
  # Bootloader
  # ------------------------
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    
    kernelParams = [
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1,RMIntrLockingMode=1"
    ];
    kernelModules = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1") [
      "hp-wmi"
    ];
    initrd.kernelModules = ["amdgpu"];   
  };

  # ------------------------
  # Display Manager
  # ------------------------
  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # ------------------------
  # Graphics Drivers
  # ------------------------
  hardware.graphics.enable = true;
  hardware.enableAllFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    prime = {
      offload.enable=true;
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ------------------------
  # Hyprland
  # ------------------------
  programs.hyprland.enable = true;

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
    git
    vim
    firefox
    kitty
    waybar
    wofi
    mako
    wl-clipboard
    grim
    slurp
  ];

  # ------------------------
  # Fonts
  # ------------------------
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
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
