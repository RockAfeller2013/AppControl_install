## Install App Control Server


- Login to https://support.broadcom.com/group/ecx/downloads
  - Search for App Control***
  - Download Linux, Windows, Mac Agent, Rules Installer and Server
  - Location - '/Volumes/PROXMOX_NFS/Carbon Black App Control'
- Install Preq
- net use Z: \\192.168.1.146\PROXMOX_NFS "" /user:guest /persistent:yes

- Set admin/Password123456
- Add Licenses
  - Go to https://support.broadcom.com/group/ecx/products
  - My Entitelements
  - Find Carbon Black App Control,
  - Download the License key
  - Copy and Paste the File Reputation License Key.
- Upload Rules, and Agents, *You need to upzio first
- Go to Polices and download the hostpkg https://192.168.1.26/host-groups.php?tab=policies&menu
