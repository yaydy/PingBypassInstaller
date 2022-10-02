#set some variables
apt install iproute2 -y
apt install screen -y
clear
internalip=$( ip -o route get to 10.0.0.0 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' ) # the ip ok
javadir=~/jdk8u345-b01/bin
hmcdir=~/HeadlessMC
modsdir=~/.minecraft/mods
mcdir=~/.minecraft/versions/1.12.2
playitcheck=~playit
launch=~pb
clear

#print the credits first, every installer ALWAYS has a stupid splash screen
echo 'brought you to the HAV0X PingBypass Rewrite by zYongSheng_'
echo  '                                                                           
██╗░░░██╗░█████╗░███╗░░██╗░██████╗░██████╗░██╗░░░██╗██████╗░░█████╗░░██████╗░██████╗
╚██╗░██╔╝██╔══██╗████╗░██║██╔════╝░██╔══██╗╚██╗░██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝
░╚████╔╝░██║░░██║██╔██╗██║██║░░██╗░██████╦╝░╚████╔╝░██████╔╝███████║╚█████╗░╚█████╗░
░░╚██╔╝░░██║░░██║██║╚████║██║░░╚██╗██╔══██╗░░╚██╔╝░░██╔═══╝░██╔══██║░╚═══██╗░╚═══██╗
░░░██║░░░╚█████╔╝██║░╚███║╚██████╔╝██████╦╝░░░██║░░░██║░░░░░██║░░██║██████╔╝██████╔╝
░░░╚═╝░░░░╚════╝░╚═╝░░╚══╝░╚═════╝░╚═════╝░░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝╚═════╝░╚═════╝░             
'
sleep 2
echo "如果您在登录 HeadlessMC 时遇到错误, 请重新运行脚本。"
sleep 1

#make sure this is being run in the home dir and not anywhere else
if [ $PWD != ~ ]; then
	echo "此脚本必须在 ~ 运行, 如有问题, 请打出此指令 | cd ~"
	exit 0
fi

#ask for user input for ip, port, password, and OS type
read -p '您想用什么Port? >> ' openport
read -p '您的PingBypass密码? >> ' pass
read -p '您的Minecraft账号? >> ' email
read -p '您的Minecraft账号密码? >> ' password

#install java if it hasnt been installed before
if [ ! -d "$javadir" ]; then
	wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
	tar -xf OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
  clear
fi

#make config files, directories and input relevant configs if they dont exist
if [ ! -d "$hmcdir" ]; then
	mkdir ~/HeadlessMC -p && touch ~/HeadlessMC/config.properties && cat >> ~/HeadlessMC/config.properties<<EOL 
hmc.java.versions=$javadir/java
hmc.invert.jndi.flag=true
hmc.invert.lookup.flag=true
hmc.invert.lwjgl.flag=true
hmc.invert.pauls.flag=true
hmc.jvmargs=-Xmx1700M -Dheadlessforge.no.console=true
EOL

	mkdir ~/.minecraft/earthhack -p && touch ~/.minecraft/earthhack/pingbypass.properties && cat >> ~/.minecraft/earthhack/pingbypass.properties<<EOL
pb.server=true
pb.ip=$internalip
pb.port=$openport
pb.password=$pass
EOL
fi

#download mods and hmc and move them to the proper places if not already downloaded
if [ ! -d "$modsdir" ]; then
	mkdir ~/.minecraft/mods -p
	wget https://github.com/3arthqu4ke/3arthh4ck/releases/download/1.8.4/3arthh4ck-1.8.4-release.jar && mv 3arthh4ck-1.8.4-release.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HMC-Specifics/releases/download/1.0.3/HMC-Specifics-1.12.2-b2-full.jar && mv HMC-Specifics-1.12.2-b2-full.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessForge/releases/download/1.2.0/headlessforge-1.2.0.jar && mv headlessforge-1.2.0.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessMc/releases/download/1.5.2/headlessmc-launcher-1.5.2.jar
fi

#download minecraft and forge if not already done and login
if [ ! -d "$mcdir" ]; then
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command download 1.12.2
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command forge 1.12.2
fi
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command login $email $password


#download playit.gg if it hasnt been already
if [ ! -d "$playitcheck" ]; then
	wget wget -q "https://playit.gg/downloads/playit-0.8.1-beta" -O playit && chmod +x playit
fi

#make launch file for pb server if it hasnt been made already
if [ ! -d "$launch" ]; then
	touch pb && cat >>~/pb<<EOL
$javadir/java -jar headlessmc-launcher-1.5.2.jar --command $@
EOL
chmod +x pb
chmod +x playit
fi

clear
echo '打此指令来开启一个新的屏幕  "screen -S PingBypass", 在这个屏幕, 打 ./pb 来开启您的PingBypass, 您应该看到 1.12.2 和 Forge 1.12.2'
echo ''
echo 'Forge 1.12.2 左边应该会有一个号码 (一般来说会是 0) 如果是0, 打出 "launch 0 -id" , 如果不是0, 打出 "launch 1 -id"'
echo ''
echo '之后, ctrl + a + d 来退出此屏幕, 现在, 你需要打出 "screen -S Port", 开启新的屏幕之后, 打出 ./playit'
echo ''
echo '这里的话, 我解释不了, 所以您需要看影片, 跟着我的步骤'
echo ''
ip -o route get to 10.0.0.0 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' && echo $openport
