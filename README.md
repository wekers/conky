## Conky Script for (Linux, FreeBSD, OpenBSD, MAC OS X) -> X Window Desktop with OpenWeather
_ _ _
###### Conky script show info about your system with Weather and Moon
###### Status of the CPU, memory, swap space, disk storage, temperatures, processes, network interface, etc..
###### For Linux, FreeBSD, OpenBSD, DragonFlyBSD, NetBSD, Solaris, Haiku OS, and macOS!
_ _ _

- - -
- - -
- - -
* * *
![print3](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_1080p_3.jpg)
* * *
##### PrintScreen 1920x1080p:

![print1](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_1080p_1.jpg)
![print2](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_1080p_2.jpg)
* * *
##### PrintScreen 1920x1080p English:
![print2](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_1080p_4.jpg)
* * *
##### PrintScreen 720p:

![print720p](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_720p.png)
* * *
##### PrintScreen Notebook 1366x768p:

![print1366](https://raw.githubusercontent.com/wekers/conky/master/printscreen/print_1366x768p.png)
* * *
* * *
* * *



### ====Usage:====

Create Account on https://home.openweathermap.org/users/sign_up
and get your "api key"

**Create folder** `~/.conky/wekers` **copy all inside**


##### Run:

**On terminal:**  `conky -c ~/.conky/wekers/.conkyrc &`

In `~/.conky/wekers/.conkyrc` file:

> Change according position, each desktop resolution is distinct ie: 30,**195**
```bash
#Day icons
${execi 310 sh ~/.conky/wekers/time.sh weather-1}${image ~/.cache/weather-1.png -p 30,195 -s 70x70 -n}
${execi 310 sh ~/.conky/wekers/time.sh weather-2}${image ~/.cache/weather-2.png -p 130,195 -s 70x70 -n} 
${execi 310 sh ~/.conky/wekers/time.sh weather-3}${image ~/.cache/weather-3.png -p 230,195 -s 70x70 -n} 
```
> print days too ie: `voffset 8 and goto 3` voffset -> (vertical position), goto -> (horizontal position)
```bash
#print days
${color}${voffset 8}${goto 3} ${execi 1000 date --date="1 day" | cut -c1-4 |tr [[:lower:]] [[:upper:]]}
```
> If you don't use **Nvidia**, comment **all** below with **#**
```livescript
#Use Nvidia
${if_match "${nvidia temp}" != "${nividia}"}${if_match "${nvidia temp}" != "N/A"}${voffset 3}${color1}Nvidia Gfx card ${color2}${hr}
${color0}GPU Gfx Model:${color8}${goto 110}${exec nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits}
${color0}GPU Frequency:${color8}${goto 110}${nvidia gpufreq} Mhz ${lua_parse gputemp temp}
${color0}Mem Frequency:${color8}${goto 110}${nvidia memfreq} Mhz${goto 165}${color0}Total Memory:${color8}${alignr}${exec nvidia-settings -q totaldedicatedGPUMemory -t}MB${else}${voffset -15}${endif}${endif}
```
_ _ _


> ###### Change all -> as your network name ie: **eth0, eth1, wlan0** etc..
```bash
# Network
${if_up eth1}${voffset 3}${color1}Network ${color}($nodename) ${color2}${hr}
```
_ _ _


> **Operational System and Kernel Version:**
###### (Slackware) ie:
```bash
${color0}Linux Kernel: ${color8}${kernel} on ${exec cat /etc/slackware-version}
```
###### (Ubuntu) ie:
```bash
${color0}Linux Kernel:${color8}${kernel} ${exec cat /etc/issue | cut -c1-15 | sed '/^$/d'}
```
_ _ _
> **File Systems:**
>
###### See It `fdisk -l` and `mount -l`
###### feel free to change
>
```bash
${voffset 3}${color1}File Systems ${color2}${hr}
${lua_parse fs / / sda1 7fff00 white}
${lua_parse fs /boot /boot sda2 7fff00 white}
${lua_parse fs /home /home sda3 7fff00 white}
```
- - -
- - -
- - -
_ _ _
> **Wind Icon:**
> 
**Green** ![wind green](https://raw.githubusercontent.com/wekers/conky/master/images/wind/green_s.png) **Orange** ![wind orange](https://raw.githubusercontent.com/wekers/conky/master/images/wind/orange_s.png) **Red** ![wind red](https://raw.githubusercontent.com/wekers/conky/master/images/wind/red_s.png) **Yellow**![wind yellow](https://raw.githubusercontent.com/wekers/conky/master/images/wind/yellow_s.png)
- - -
> ###### Change as you more like
###### In `time.sh`
>
###### Replace --> green, orange, red and yellow
```bash
wicon)
	  cp -f ${DirShell}/images/wind/orange_$(grep "direction" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f4 | tr [[:upper:]] [[:lower:]] | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g').png ~/.cache/wind.png
	  ;;
```
- - - -


* * *


### **- Get Weather:**
`~/.conky/wekers/.conkyrc` file:
```lua
# Get Weather data
# examples https://openweathermap.org/current and https://openweathermap.org/api/hourly-forecast

${execi 300 curl "https://api.openweathermap.org/data/2.5/weather?q="your country here"&units=metric&lang=pt&mode=xml&appid="your key"" | xmllint --format - > ~/.cache/weather_current_aux.xml} 
${execi 300 if grep --quiet current ~/.cache/weather_current_aux.xml; then cp ~/.cache/weather_current_aux.xml ~/.cache/weather_current.xml; fi}

${execi 300 curl "https://api.openweathermap.org/data/2.5/forecast?q="your country here"&units=metric&lang=pt&mode=xml&appid="your key"" | xmllint --format - > ~/.cache/weather_aux.xml} 
${execi 300 if grep --quiet weatherdata ~/.cache/weather_aux.xml; then cp ~/.cache/weather_aux.xml ~/.cache/weather.xml; fi}
```








* * *

- - -
- - -
- - -
### **Installation:**

- - -

##### **Compiling from Source:**

```cmake
./configure --enable-hddtemp --enable-mpd --enable-moc --enable-rss --enable-lua --enable-lua-cairo --enable-weather-metar --enable-weather-xoap --enable-lua-imlib2 --enable-wlan --enable-portmon --enable-imlib2 --enable-nvidia

make
make install
```

**Packages Required:**
- libncurses5-dev
- libx11-dev
- libimlib2-dev
- libcairo-dev
- lua5.2.4
- liblua5.3-dev
- libtolua++5.1-dev
- libiw-dev
- libxft-dev
- libxdamage-dev
- libxext-dev
- libxnvctrl-dev
- libcurl4-openssl-dev
- libxml2-dev
- hddtemp



**For macOS you can get the required libraries using these commands:**
```cmake
brew install cmake freetype gettext lua imlib2 pkg-config
brew link gettext --force
```

- - -
- - -
- - -
- - -
* * *

##### P.S.: Some CPU's get error in temperature. to fix:

```lua
-- CPU and mainboard temperature
function conky_temperature (sensor)
	local t = ""
 	if ( sensor == "CPU" ) then t = CPU	else t = MB end
	if ( t == nil ) then
		if ( sensor == "CPU" ) then t = "${color0}Temperature: ${color}${alignr}${hwmon temp 2}" .. DEG else t = "" end
	else
		t = t .. DEG
	end
	return t
end
```

##### Change in file **conky.lua**
```lua
${hwmon temp 2}
```
to
```lua
${hwmon temp 1}
```
_ _ _

##### hddtemp issue, to fix:
###### `sudo dpkg-reconfigure hddtemp`
###### `sudo chmod +s /usr/sbin/hddtemp`

###### **see on terminal if work** `nc localhost 7634`

* * *


