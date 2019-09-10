-- conky.lua
-- this script is called by conky to create color gradients, set the color of the 
-- weather icon and parse log files.    

do

local HWMON = ""
local noMP  = { "nfs" , "local/mnt" }
local eth   = "eth0"
local DEG   = "°C"
local BUL   = "°"
local wip   = ""
local fsize = 9

-- ------------------------------------------------------------------------------------
-- init functions
-- ------------------------------------------------------------------------------------
-- These functions are run only once when conky starts.

-- switch own_window_argb_visual for KDE/non KDE transparency.
function getargb(cfg)  
	for line in assert(io.lines(cfg)) do
    	if line:find("own_window_argb_visual") then
			argb = line:gsub('.* ', "")
		end
	end
	return argb	
end

function writeargb(cfg, argb)
	file = assert(io.open(cfg, 'r+'))
	for line in assert(io.lines(cfg)) do
    	if line:find("own_window_argb_visual") then
			file:write("own_window_argb_visual " .. argb .."\n")
		else
			file:write(line .. "\n")
		end
	end
	file:close()
end

function setargb(...)
	local wm  = os.getenv('WINDOWMANAGER')
	local cfg = conky_config
	local argb = getargb(cfg)

	if wm == "kde" then
		if argb == "no" then
			writeargb(cfg,"yes")
		end	
	else 
		if argb == "yes" then
			writeargb(cfg,"no")
		end	
	end
end

function getsensors(...)
 	local t = ""
	l = assert(io.popen("find -L /sys/class/hwmon/hwmon* -maxdepth 1 -regextype posix-awk -regex '.*temp[0-9]_(label|crit|input)' -exec echo -n '{}=' ';' -exec cat '{}' ';' 2>/dev/null | sed 's|/sys/class/hwmon/hwmon||;s|/temp||;s| |_|g;s|_| |;s|=|=|;s|$||' | sort | awk '{ if ( P == $1 ) { print \"#\",  $NF } else print ; P=$1 }' | sed -e :a -e '$!N;s/\\\n#/ /;ta' -e 'P;D' | awk '{ if ( $4 ~ /label/ ) print $4, $1, $2, $3 ; else print \"label=MB Temperature\", $1, $2, $3}' | sed 's|label=||' | awk '{ if ( $3 ~ /crit/ ) print $1, $2, $3 ; else print $1, $2, $3, \"crit=10000\" }' | sed 's|_| |; s|crit=||;s|\\(.*\\) \\(.*\\) \\([0-9]\\)\\([0-9]\\) \\([0-9][0-9]*\\)|\\1 = \"${color0}\\1 \\2: ${color8}${if_match ${hwmon \\3 temp \\4}>=\\5}${color red}${endif}${alignr}${hwmon \\3 temp \\4}\"|'"))
	for s in l:lines() do
	    assert(loadstring(s))()
	end
	l:close()
 	return t
end

function getfs (...)
	l = assert(io.popen("eval $(df -hl -x tmpfs -x devtmpfs -x rootfs 2>/dev/null | sed -e '/nfs/d' -e :a -e '$!N;s/\\\n //;ta' -e 'P;D' | awk '/^\\\/dev/ { printf \"echo -n %s: ; basename $(readlink -f %s) | tr -d \\\"-\\\" ;\", $NF,  $1}') | awk -F \":\" '{ sub(/sd./, \"&0\", $2) ; if ( length($2) >= 6 ) sub(/0/,\"\",$2) ; print \"fs.\" $2 \" = \\\"\" $1 \"\\\"\"}'" ))
	fs = {}
 	for s in l:lines() do assert(loadstring(s))() end
	for p,f in pairs (fs) do 
  		for i,v in ipairs(noMP) do 
  			if (f:find(v)) then fs[p] = nil end
  		end
	end
	l:close()
end

function gethd (...)
	l = assert(io.popen("find /dev -maxdepth 1 -type b -name 'sd[a-z]' -exec basename '{}' ';' 2>/dev/null | sort 2>/dev/null"))
	dev = {}
 	for s in l:lines() do table.insert(dev, s) end
	l:close()
end

-- get InternetIP
function getip(...)
	local t=""
	l = assert(io.popen("wget -q -O - checkip.dyndns.org | sed -e 's/[^[:digit:]\|.]//g'"))
	for s in l:lines() do t = s end
	l:close()
	return t
end

-- get xftfont size
function getfsize(...)
	local t=""
	for line in assert(io.lines(conky_config)) do
		if line:find("xftfont") then t = line:gsub(".*:size=(%d)", "%1") end
	end
	return tonumber(t)
end

-- set conky update interval
function conky_set_interval (i)
	local t = tonumber(i)
	conky_set_update_interval(t)
end


function conky_init(i)
-- 	setargb()
	getsensors()
	l = assert(io.popen("/sbin/route 2>/dev/null | awk '/^default/ { print $NF }' | head -1"))
	for s in l:lines() do NIC = s end
	l:close()
	if ( NIC == nil ) then NIC = eth end
	local v  = conky_version
	local V = v:gsub('_.*', '')
	V = V:gsub('%p', '')
	v = tonumber(V)
	wip = getip()
	if ( v >= 181 ) then
		getfs()
		l = assert(io.popen("getconf  _NPROCESSORS_ONLN"))
		for s in l:lines() do CPUS = tonumber(s) end
		l:close()
		gethd()
	end
	if ( i == nil ) then u = conky_info.update_interval else u = i end
	conky_set_interval(u)
end

-- ------------------------------------------------------------------------------------

-- convert Celsius to Fahrenheit
function toFahrenheit (temp)
	local t = tonumber(temp)
	t = t * 9 / 5 + 32
	return t
end

-- this function changes Conky's top colour based on a threshold
function top_colour(value, default_colour, upper_thresh, lower_thresh)
	local r, g, b = default_colour, default_colour, default_colour
	local colour = 0
	local thresh_diff = upper_thresh - lower_thresh
	if (value == nil ) then value = 0 end
	if (value - lower_thresh) > 0 then
		if value > upper_thresh then value = upper_thresh end
		-- add some redness, depending on the 'strength'
		r = math.ceil(default_colour + ((value - lower_thresh) / thresh_diff) * (0xff - default_colour))
		b = math.floor(default_colour - ((value - lower_thresh) / thresh_diff) * default_colour)
		g = b
	end
	colour = (r * 0x10000) + (g * 0x100) + b -- no bit shifting operator in Lua afaik
	return string.format("${color #%06x}", colour%0xffffff)

end

-- parses the output from top and calls the colour function
function conky_top (p,n)
	c = ""
	top = "top"
	if ( p == "mem" ) then top = "top_mem" end
	u = tonumber(conky_parse('${' .. top .. ' ' .. p .. ' ' .. n ..'}'))
	c = string.format("%s${top name %s}${alignr 80}${%s pid %s}${alignr 45}${%s cpu %s}${alignr 20}${%s mem %s}", top_colour(u, 0xd3, 25, 5), n, top, n, top, n, top,n)
	return c
end

-- refresh after s seconds
function refresh(s)
	local n = 0
	local u = conky_parse('${updates}')
	local i = conky_info.update_interval
	local x = math.ceil(s/i)
	n = math.fmod(u, x)
	return n
end

-- display the n top processes
function conky_tops (p,n)
	t = ""
	top = "top"
	if ( p == "mem" ) then top = "top_mem" end
	for i=1,tonumber(n) do
		usage = tonumber(conky_parse('${' .. top .. ' ' .. p .. ' ' .. i ..'}'))
		color = top_colour(usage, 0xd3, 25, 5)
--		u = string.format("%s${%s name %s}${alignr 80}${%s pid %s}${alignr 45}${%s cpu %s}${alignr 20}${%s mem %i}", color, top, i, top, i, top, i, top, i)
		u = conky_top(p,i)
		if ( t == "" ) then t = u else t = t .. "\n" .. u end
	end
	return t
end

-- perform linear interpolation of two colors
function interpolate(color1,color2,value,valuemax)
	local endcolor
	if color1 < color2 then
		endcolor=((color2 - color1) * (value/valuemax)) + color1
	else
		endcolor=((color1 - color2) * (1 - (value/valuemax))) + color2
	end
	return math.ceil(endcolor)
end

-- get a color on a gradient between the given color an red
function gradient (u,color)
	local c=color
	local r,g,b = tonumber('0x' .. c:sub(1,2)), tonumber('0x' .. c:sub(3,4)), tonumber('0x' .. c:sub(5,6))
	local r2,g2,b2 = 0xAD, 0x00, 0x00
	local r3=interpolate(r,r2,u,100)	
	local g3=interpolate(g,g2,u,100)	
	local b3=interpolate(b,b2,u,100)	
	local colour = (r3 * 0x10000) + (g3 * 0x100) + b3 
	return string.format("${color #%06x}", colour%0xffffff)
end

-- colors fs bar according percentage of usage
function fsbar (fs,bgcolor,fgcolor)
	local percent=conky_parse('${fs_used_perc ' .. fs .. '}')
	local u=tonumber(percent)
	local fg=fgcolor
	if u < 10 then percent =  ' ' .. percent end
	return string.format("%s${fs_bar %s}${offset -55}${color %s}%s%%", gradient(u,bgcolor), fs, fg, percent)
end

-- colors cpu bar according percentage of usage
function conky_cpubar (cpu,bgcolor,fgcolor)
	local percent=conky_parse('${cpu cpu' .. cpu .. '}')
	local u=tonumber(percent)
	local fg=fgcolor
	if u < 10 then percent =  ' ' .. percent end
	return string.format("%s${cpubar cpu%s 10,115}${offset -65}${color %s}%s%%", gradient(u,bgcolor), cpu, fg, percent)
end

-- colors apcupsd bar according percentage of usage
function conky_apcbar (bgcolor,fgcolor)
	local t = ""
	local percent = conky_parse('${apcupsd_load}')
	if ( percent ~= "N/A" ) then
	 	local charge  = conky_parse('${apcupsd_charge}')
 		local u = math.floor(tonumber(percent))
 		local l = math.floor(tonumber(charge))
 		percent = u	
 		charge = l
 		local fg = fgcolor
 		local bg = bgcolor
 		if u < 10 then percent =  ' ' .. percent end
 		t = string.format("${color8}${apcupsd_status}${offset 10}%s${apcupsd_loadbar}${offset -55}${color %s}%s%%${color8}${alignr 30}%s%%${alignr 20}${apcupsd_timeleft}mn${alignr 5}${apcupsd_linev}V", gradient(u,bg), fg, percent, charge)
	end
	return t
end

-- draw CPU bars
function conky_cpubars (bg,fg)
	local t = ""
	for i = 1,CPUS	do
		if ( i % 2 == 0 ) then U = "${goto 165}" else U = "" end
		u = U .. string.format("${color0}CPU%s:${offset +4}", i) .. conky_cpubar(i, bg, fg)
 		t = t .. u 
		if ( i < CPUS and i % 2 == 0) then  t = t .. '\n' end
	end
	return t
end

--  display mounted filesystems
function conky_fs(f,n,p,bar_color,pct_color)
	local t = ""
 	t = string.format("${if_mounted %s}${color3}%s${goto 45}${color7}%s${goto 120}${alignr}${color4}${fs_used %s}${color}/${alignr 10}${color5}${fs_size %s}${goto 220}${alignr}%s${endif}", f, p, n, f, f, fsbar(f, bar_color, pct_color))
	return t
end

function conky_getfs(bg,fg)
	local t = ""
	pt = {} 
	for p,f in pairs (fs) do table.insert(pt,p) end
	table.sort(pt)
	for i,v in ipairs (pt) do 
		s = fs[v]
		p = v:gsub("(sda)0", "%1")
 		u = conky_fs(s,p,bg,fg)
 		if ( t == "" ) then t = u else t = t .. '\n' .. u end
	end
	return t
end

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

-- return the degree symbole
function conky_deg ( ... )
	return DEG
end

function conky_bul ( ... )
	return BUL
end

-- GPU temperature (nvidia)
function conky_gputemp (s)
	local t = ""
	local cap = { temp="GPU Temperature" , ambient="Case Temperature" }
	local tmp = assert(conky_parse('${nvidia ' .. s .. '}'))
	if ( tmp == "${nvidia}" ) then return t end
	local ths = assert(conky_parse('${nvidia threshold}'))
	if ( ths ~= "N/A" ) then threshhold = 1000 else threshhold = tonumber(ths) end
	if ( tmp == "N/A" ) then
		T = tmp
		c = 0
	else
		U = tonumber(tmp)	
		if ( U >= threshhold ) then c = 4 else c = 8 end
		T = tmp .. DEG
	end
	t = string.format("${goto 165}${color0}%s: ${color%s}${alignr}%s", cap[s], c, T)
	return t
end

-- Disk IO
function conky_diskio(color1, color2, color3, color4)
	local t = ""
	S = # dev
	if ( S > 0 ) then
		t = string.format("${voffset 3}${color1}Disk IO ${color2}${hr}\n${color0}dev${alignr 162}write${alignr 122}read${alignr 90}temp")
		for i,s in ipairs(dev) do
			u = string.format("${color3}%s${alignr 220}${color %s}${diskio_write %s}\n${voffset -12}${alignr 60}${color8}${diskio_read %s}${goto 200}${alignr 20}${color %s}${hddtemp /dev/%s}°C${alignr 5}${color9}${diskiograph %s 12,70 %s %s 0 -t -l}", s, color1, s, s, color2, s, s, color3, color4)
 			t = t .. '\n' .. u
		end
	end
	return t
end

-- monitor apcupsd
function conky_apcupsd(s,bgcolor,fgcolor)
	t = ""
	local sp = s
	local fg = fgcolor
	local bg = bgcolor
	u = conky_apcbar(bg,fg)
	if ( u ~= "" ) then t = string.format("${if_match \"${apcupsd_model}\" != \"N/A\"}${voffset %s}${color1}APC: ${color6}${apcupsd_model}${color2}${hr}\n${color6}status${goto 60}load${alignr 32}charge${alignr 25}timeleft${alignr 15}linev\n%s${endif}",s,u) end
	return t
end

-- get InternetIP
function conky_wanip(i)
	local t = ""
	if ( i == nil ) then i = 0 end
	n = tonumber(refresh(tonumber(i)))
	if ( n == 0 ) then t = getip() else t = wip end
	return t
end

-- diplay network infos
function conky_network (vspace, color1, color2, color3, color4, color5, color6, chkip)
	local t = ""
	if (chkip == nil ) then chkip = 0 end
	c = tonumber(chkip)
	if ( c > 0 ) then i = string.format(" ${color0}WAN IP: ${color4}${goto 60}%s", conky_wanip(c)) else i = "" end
	t = string.format("${if_up %s}${voffset %s}${color1}Network ${color}($nodename) ${color2}${hr}\n ${color}%s:${color0}Down:${color %s}${downspeed %s}/s${color0}${goto 190}Up:${color %s} ${upspeed %s}/s\n ${color9}${downspeedgraph %s 24,150 %s %s} ${color9}${upspeedgraph %s 24,150 %s %s}\n ${color0}LAN IP: ${color}${goto 60}${addr %s}${if_gw}${goto 180}${color0} gw: ${goto 215}${color}${gw_ip}\n%s$endif${goto 180}${color0}dns: ${goto 215}${color}${nameserver}${endif}", NIC, vspace, NIC, color1, NIC, color2, NIC, NIC, color3, color4, NIC, color5, color6, NIC, i)
	return t
end

-- monitor tcp ports
function conky_tcpmon (startport, endport, i)
	local t = ""
	h = conky_parse('${tcp_portmon ' .. startport .. ' ' .. endport .. ' rip ' .. i .. '}')
	p = conky_parse('${tcp_portmon ' .. startport .. ' ' .. endport .. ' lservice ' .. i .. '}')
	if ( h == "127.0.0.1" ) then chost = '${color grey30}' else chost = "" end
	if ( p == "ssh" or p == "nfs" ) then cport = '${color red}' else cport = "" end
	t = string.format("${color6}%s%s${tcp_portmon %s %s lservice %s}${goto 65}${color7}%s%s${tcp_portmon %s %s rhost %s}${alignr 5}${color3}%s%s${tcp_portmon %s %s rip %s}", cport, chost, startport, endport, i, cport, chost, startport, endport, i, cport, chost, startport, endport, i)
	return t
end

function conky_tcpmons (vspace, toptcp, startport, endport)
	local t = ""
	local m = toptcp
	if (m == nil ) then m = 0 end
	max = tonumber(m)-1
	if (max > 0 ) then	
		t = string.format("${if_up %s}${voffset %s}${color1}Tcp connections: ${color5}${tcp_portmon %s %s count} ${color6}(top %s)${color2}${hr}\n", NIC, vspace, startport, endport, toptcp)
	 	for i=0,max do
			u = conky_tcpmon(startport, endport, i) .. "\n"
			t = t .. u
		end
		t = t .. "${endif}"
	end
	return t
end

-- split a string into lines
function str2table(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

-- parse log files
function conky_parselog (...)
	local logfile,n,color,noparse
	if (arg[1]) then logfile = arg[1] else return "" end
	if (arg[2]) then n = tonumber(arg[2]) else n = 3 end
	if (arg[3]) then color = arg[3] else color = 'ff0000' end
	if (arg[4]) then noparse = arg[4] else noparse = 1 end
	if n > 30 then n = 30 end

--	local log = str2table(conky_parse('${tail ' .. logfile .. ' ' .. n .. '}')) 

--  use "sudo tail" to parse the log files instead of conky ${tail}. so that
--  members of the wheel group have read access to log files.
	local l = assert(io.popen("sudo -n tail -2000 " .. logfile ..  " 2>/dev/null | grep -v " .. logfile .. "| grep -v 'sudo: last message repeated' | tail -" .. n))
	
	log = {}
 	for s in l:lines() do table.insert(log, s) end
	l:close()

	local i = table.getn(log)
	if i == 0 then
		 return string.format("%s not readable.", logfile)
	end
	local s = 0
	if i > n then 
		s = i - n
	end
	local lines, line = ""
	while i > s do
		line=log[i]
		line = line:gsub("%$", "%%$$")
		line = line:gsub("%+", "%%+")
		line = line:gsub("%*", "%%*")
		if noparse == 1 then
			line=line:gsub('%w*  *%w*  *([%d:]*)  *%w*  *(%w.-_*)(:*) *[[ %d.]*]', "${color aaaaaa}%1 ${color white}%2%3", 1)
			line=line:gsub(logfile:gsub('/.*/(%w*).*',"%1: ",1),"",1)
			line=line:gsub(': ',": ${color " .. color .."}",1)
			line=line:gsub('#',"\\#")
			line=line:gsub('%w*  *%w*  *([%d:]*)  *%w*  *(%w.-_*): *', "${color aaaaaa}%1 ${color white}%2: ${color " .. color .."}",1) 
		else
			line=string.format("${color %s}", color) .. line
		end	
		line = line:gsub("%%([+$*])", "%1")
		if ( lines ==  "" ) then lines = line else lines = lines .. '\n' .. line end
		i = i -1
	end	
	return lines
end
end