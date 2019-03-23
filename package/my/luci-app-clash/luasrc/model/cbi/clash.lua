#-- Copyright (C) 2018 dz <dingzhong110@gmail.com>

local sys = require("luci.sys")
local util = require("luci.util")
local fs = require("nixio.fs")

if luci.sys.call("pidof clash >/dev/null") == 0 then
	m = Map("clash", translate("clash"), "%s - %s" %{translate("clash"), translate("<strong><font color=\"green\">Running</font></strong>")})
else
	m = Map("clash", translate("clash"), "%s - %s" %{translate("clash"), translate("<strong><font color=\"red\">Not Running</font></strong>")})
end
local trport = 9090
local button = ""
button = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"button\" value=\" " .. translate("Open Web Interface") .. " \" onclick=\"window.open('http://'+window.location.hostname+':" .. trport .. "')\"/>"

m = Map("clash", translate("clash") .. button)
-- Basic
s = m:section(TypedSection, "clash", translate("Settings"), translate("The following parameters are used to set the firewall forwarding rules,Need to be consistent with the clash configuration file"))
s.anonymous = true

---- Eanble
enable = s:option(Flag, "enabled", translate("Enable"), translate("Enable or disable clash server"))
enable.default = 0
enable.rmempty = false

o = s:option(Value, "proxy_port", translate("* Proxy Port"))
o.default = 7982
o.datatype = "port"
o.rmempty = false

o = s:option(Value, "dns_server", translate("* DNS Server"))
o.default = "127.0.0.1#5858"
o.rmempty = false

o = s:option(Value, "server", translate("Server Address"), translate("If you have only one CLASH server IP and can choose different ports, set this bar"))
o.rmempty = true

o = s:option(Value, "server_port", translate("Server Port"), translate("Remote CLASH servers provide service ports. If you have multiple IPS available, but the ports are identical, set this"))
o.datatype = "port"
o.rmempty = true

o = s:option(Value, "socks5_port", translate("SOCKS5 Port"), translate("Local proxy port"))
o.datatype = "port"
o.rmempty = true

-- Doman addresss
s = m:section(TypedSection, "clash", translate("clash conf"), 
	translate("clash conf"))
s.anonymous = true

---- address
addr = s:option(Value, "address",
	translate(""), 
	translate("-------------------------------------------------------------------- " ..
	  "----------------------------------------------------------------------------. " ..
	  ""))

addr.template = "cbi/tvalue"
addr.rows = 30

function addr.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/clash/config.yml")
end

function addr.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("/etc/clash/config.yml", value)
end

return m
