# TUTORIAL Install OS Windows by SHARE IT HUB

## 1. Script OS downlaoder :
```
sudo wget https://raw.githubusercontent.com/shareithub/install-OS-rdp/refs/heads/main/install.sh
```

## 2. Run script OS :
```
chmod +x install.sh
./install.sh
```

## 3. After done, connect your IP VPS to VNC

## 4. Install & setting your OS. ( u can check in this video ) >> [YOUTUBE : CLICK HERE](https://youtu.be/U-Uhf28c8WA)

## 5. `CTRL+C` script OS downloader.

## 6. Copy this code to compress file Windows after your setting :

`dd if=windowsxx.img | gzip -c > windowsxx.gz` > windowsxxx. change to your windows file. 

Ex : `dd if=windows22.img | gzip -c > windows22.gz`

## 7. Install Apache : 

`apt install apache2`

## 8. Allow firewall Apache : 

`sudo ufw allow 'Apache'`

## 9. Access your file in browser & backup or download your file : 

`cp windowsxx.gz /var/www/html/` > windowsxxxx. change your windows file. 

Ex : `cp windows22.gz /var/www/html/`

## 10. Open browser & access this. to download your OS Windows after setting : 

`http://127.0.0.1/windowsxx.gz` >> change 127.0.0.1 to your IP VPS & windowsxxxx to your windows file

