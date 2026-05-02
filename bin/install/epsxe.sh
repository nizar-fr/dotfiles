# prepare directory. Specify it.
mkdir -p ~/temp_hd/game/ps1/

# download ePSXe
cd ~/temp_hd/game/ps1/
wget http://www.epsxe.com/files/ePSXe205linux_x64.zip
unzip ePSXe205linux_x64.zip
chmod +x epsxe_x64

# install dependencies using APT
sudo apt install libncurses5 libsdl1.2debian libsdl-ttf2.0-0 -y

wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
sudo apt-get install ./libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb

# install libcurl3 locally by unpacking deb-package
wget http://archive.ubuntu.com/ubuntu/pool/universe/c/curl3/libcurl3_7.58.0-2ubuntu2_amd64.deb
dpkg -x libcurl3_7.58.0-2ubuntu2_amd64.deb /tmp/libcurl
mv /tmp/libcurl/usr/lib/x86_64-linux-gnu/libcurl.so.4* .

# run ePSXe specifying path to the library
LD_LIBRARY_PATH=$HOME/temp_hd/game/ps1/ ./epsxe_x64
