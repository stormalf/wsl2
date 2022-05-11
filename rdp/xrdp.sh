sudo apt-get -y install xrdp xfce4 xfce4-goodies
sudo cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.bak`date +"%d-%m-%Y"`
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak`date +"%d-%m-%Y"`
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
echo xfce4-session > ~/.xsession

sudo sed -i 's/test -x \/etc\/X11\/Xsession && exec \/etc\/X11\/Xsession/#&/g' /etc/xrdp/startwm.sh
sudo sed -i 's/exec \/bin\/sh \/etc\/X11\/Xsession/#&/g' /etc/xrdp/startwm.sh
sudo sh -c "echo '#xfce\nstartxfce4' >> /etc/xrdp/startwm.sh"
sudo /etc/init.d/xrdp start
sudo /etc/init.d/xrdp status
