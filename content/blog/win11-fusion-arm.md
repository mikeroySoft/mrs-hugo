+++
author = "Michael Roy"
categories = ["Blog"]
date = "2022-07-28"
description = "Running Windows 11 with Fusion on Apple Silicon"
featured = "fusion-as.png"
featuredalt = "VMware Fusion and Windows 11 running on an M1 Mac"
featuredpath = "/2022/07/"
linktitle = "Running Windows 11 on M1 Macs with Fusion "
title = "Windows 11 on M1 with Fusion"
type = "draft"

+++

## Running Windows 11 on Apple Silicon with VMware Fusion
The VMware Fusion 22H2 Tech Preview is finally out and the big new feature is support for Windows on Apple Silicon. This is a bit different from Intel, as Microsoft doesn't make getting the required .iso file as easy as it is for x86. There are two ways to install Windows, with the first is by using the traditional .iso file and the second being to convert from a .VHDX that Microsoft provides, we'll cover getting and using a .iso file to install from. 

An .iso file is usually what OEMs and system builders use to install Windows on physical hardware, but as virtual machines grew in popularity, the .iso file became the standard unit for installing operating systems from scratch in VMs. One great thing about installing from scratch using an .iso, you end up with a fresh installation that is unpolluted by what has affectionately become known as 'crapware' bundled on most PCs these days. In my experience, running Windows in a VM installed from .iso has always been a superior experience to running it on a physical device, but maybe that's just me.

As mentioned, the second method for installing Windows is to convert a prebuilt image that Microsoft provides from the Hyper-V .VHDX format to a .vmdk using the 3rd party tool QEMU, and I'll cover that another post [over here](win11-via-vhdx).

### UUPDump.net

To get the .iso file, we'll use a service to generate a .iso file using publicly-available OS files from Microsoft's Unified Update Program ("UUP") service. The files come directly from MS, but the script we'll create uses the tool Aria2 to download and assemble them. We'll specify which builds, editions, languages, architectures and other customization options that we want to use at [uupdump.net](uupdump.net), and the website will create a small script to download and run on your Mac. The script will to do all the downloading and building of your image based on your settings from [uupdump](uupdump.net). With the dependencies installed, we can just run the script to generate the .iso file of our liking, and that .iso file can then be used to install into a VM with Fusion.

1. Install Aria2 and dependencies (note: requires [Homebrew](https://brew.sh)): 
```
brew install aria2
```
2. Go to uupdump.net and create your iso download package

You can now use the generated .iso file to install Windows 11 with.



