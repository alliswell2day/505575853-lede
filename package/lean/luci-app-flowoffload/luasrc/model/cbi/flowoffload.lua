local m,s,o
local SYS  = require "luci.sys"

m = Map("flowoffload")
m.title	= translate("Turbo ACC Acceleration Settings")
m.description = translate("Opensource Linux Flow Offload driver (Fast Path or HWNAT)")
m:append(Template("flow/status"))

s = m:section(TypedSection, "flow")
s.addremove = false
s.anonymous = true

flow = s:option(Flag, "flow_offloading", translate("Enable"))
flow.default = 0
flow.rmempty = false
flow.description = translate("Enable software flow offloading for connections. (decrease cpu load / increase routing throughput)")

hw = s:option(Flag, "flow_offloading_hw", translate("HWNAT"))
hw.default = 0
hw.rmempty = true
hw.description = translate("Enable Hardware NAT (depends on hw capability like MTK 762x)")
hw:depends("flow_offloading", 1)

bbr = s:option(Flag, "bbr", translate("Enable BBR"))
bbr.default = 0
bbr.rmempty = false
bbr.description = translate("Bottleneck Bandwidth and Round-trip propagation time (BBR)")

dns = s:option(Flag, "dns", translate("DNS Acceleration"))
dns.default = 0
dns.rmempty = false
dns.description = translate("Enable DNS Cache Acceleration and anti ISP DNS pollution")

o = s:option(Value, "dns_server", translate("Upsteam DNS Server"))
o.default = "1.0.0.1,1.1.1.1,1.2.4.8,4.2.2.1,4.2.2.2,8.8.4.4,8.8.8.8,9.9.9.9,114.114.114.114,114.114.115.115,119.28.28.28,119.29.29.29,180.76.76.76,210.2.4.8,208.67.220.220,208.67.222.222,223.5.5.5,223.6.6.6,240c::6644,240c::6666,2400:da00::6666,2001:4860:4860::8844,2001:4860:4860::8888,2606:4700:4700::1001,2606:4700:4700::1111"
o.description = translate("Muitiple DNS server can saperate with ','")
o:depends("dns", 1)

return m
