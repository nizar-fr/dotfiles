wget http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.4/en_us/FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
cd ~/Downloads
tar xzvf FoxitReader*.tar.gz
sudo chmod a+x FoxitReader*.run
sudo ./FoxitReader*.run
sudo rm -rf ./FoxitReader*.tar.gz
sudo rm -rf ./FoxitReader*.run
