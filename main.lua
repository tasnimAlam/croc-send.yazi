--- @since 25.5.28

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function fail(s, ...)
	ya.notify {
		title = "croc-send",
		content = string.format(s, ...),
		level = "error",
		timeout = 5,
	}
end

return {
	entry = function(self, job)
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify {
				title = "croc-send",
				content = "No file selected",
				level = "warn",
				timeout = 5,
			}
		end

		local args = { "send" }

		-- Optional custom passphrase as first positional argument:
		--   plugin croc-send -- mypassphrase
		local code = job and job.args and job.args[1]
		if type(code) == "string" and code ~= "" then
			table.insert(args, "--code")
			table.insert(args, code)
		end

		for _, url in ipairs(urls) do
			table.insert(args, url)
		end

		-- Hand the terminal back to the user so croc's interactive
		-- output (passphrase + progress bar) is fully visible.
		local permit = ui.hide()

		local child, err = Command("croc")
			:arg(args)
			:stdin(Command.INHERIT)
			:stdout(Command.INHERIT)
			:stderr(Command.INHERIT)
			:spawn()

		if not child then
			permit:drop()
			return fail("Failed to spawn croc: %s", err)
		end

		local status, wait_err = child:wait()
		permit:drop()

		if not status then
			return fail("croc exited abnormally: %s", wait_err)
		elseif not status.success then
			fail("croc failed with exit code %d", status.code)
		end
	end,
}
