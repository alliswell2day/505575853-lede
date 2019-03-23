#-- Copyright (C) 2018 dz <dingzhong110@gmail.com>

module("luci.controller.clash", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/clash") then
		return
	end

	local page

	page = entry({"admin", "services", "clash"}, cbi("clash"), _("CLASH"), 60)
	page.dependent = true
end
