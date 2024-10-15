#wine64 installation
  sudo apt install wine64 #wine32 if 32bit cpu
  wineboot
  wine --version
  sudo apt upgrade
  
#masm32 installation
  curl -o masm32v11r.zip https://masm32.com/download/masm32v11r.zip
  unzip masm32v11r.zip
  cd ~/Downloads/masm32v11r
  wine start install.exe

#creation of script to run .asm file
  mkdir ~/assembly/
  cd ~/assembly/
  touch ./build.sh
  chmod +x build.sh
  cat << 'EOF' > build.sh
#!/bin/bash
filename=$1
wine "C:\\masm32\\bin\\ml.exe" /c /coff /Cp "$filename.asm"
wine "C:\\masm32\\bin\\link.exe" -entry:main /subsystem:console "$filename.obj"
wine "$filename.exe"
EOF
