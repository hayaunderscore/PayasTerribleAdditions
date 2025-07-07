-- Thou shan't be loaded twice!
if not q_rankloader then
	q_rankloader = {}
	q_rankloader.patterns = {
		-- something:get_id() % id == id
		{
			patt = "([%w_.#]+):get_id%(%s*%)%s*%%%s*([%w_.%(%)#]+)%s*==%s*([%w_.%(%)#]+)",
			repl = "ids_op(%1, \"mod\", %2, %3)",
		},
		-- something[index]:get_id() % id == id
		{
			patt = "([%w_.#]+%b[]):get_id%(%s*%)%s*%%%s*([%w_.%(%)]+)%s*==%s*([%w_.%(%)]+)",
			repl = "ids_op(%1, \"mod\", %2, %3)"
		}
	}
	q_rankloader.cache = {}
	q_rankloader.cached_sizes = {}
	-- add other operators
	local ops = { ">=", "<=", "~=", "==", ">", "<" }
	for _, op in ipairs(ops) do
		local esc = op:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
		-- something:get_id() [op] other:get_id()
		table.insert(q_rankloader.patterns, {
			patt = "([%w_.#]+):get_id%(%s*%)%s*" .. esc .. "%s*([%w_.#]+):get_id%(%s*%)",
			repl = "ids_op(%1, \"" .. op .. "\", %2:get_id())"
		})
		-- something:get_id() [op] id
		table.insert(q_rankloader.patterns, {
			patt = "([%w_.#]+):get_id%(%s*%)%s*" .. esc .. "%s*([%w_.#]+)",
			repl = "ids_op(%1, \"" .. op .. "\", %2)"
		})
		-- something[index]:get_id() [op] other[index]:get_id()
		table.insert(q_rankloader.patterns, {
			patt = "([%w_.#]+%b[]):get_id%(%s*%)%s*" .. esc .. "%s*([%w_.#]+%b[]):get_id%(%s*%)",
			repl = "ids_op(%1, \"" .. op .. "\", %2:get_id())"
		})
		-- something[index]:get_id() [op] other:get_id()
		table.insert(q_rankloader.patterns, {
			patt = "([%w_.#]+%b[]):get_id%(%s*%)%s*" .. esc .. "%s*([%w_.%(%)]+)",
			repl = "ids_op(%1, \"" .. op .. "\", %2)"
		})
	end
	-- TARGET: insert other_patch_text additions here

	q_rankloader.patch_text = function(txt)
		if not txt:find("get_id", 1, true) then
			return txt
		end
		for _, p in ipairs(q_rankloader.patterns) do
			txt = txt:gsub(p.patt, p.repl)
		end
		return txt
	end
end

if not q_rankloader.hooked_require then
	--local orig_searchers = package.searchers or package.loaders
	table.insert(package.loaders, 1, function(modname)
		local path = modname:gsub("%.", "/") .. ".lua"
		if q_rankloader.cache[path] then
			return q_rankloader.cache[path]
		end
		if path:lower():match("misc_functions%.lua")
			or not love.filesystem.getInfo(path)
			or SMODS -- HOPEFULLY this prevents any outside smods loading by accident
		then
			return "\n\t[patched loader skipped]"
		end
		local ok, txt = pcall(love.filesystem.read, path)
		if not ok or not txt then
			return "\n\t[patched loader skipped]"
		end
		local fn, err = load(q_rankloader.patch_text(txt), path)
		if not fn then error(err) end
		q_rankloader.cache[path] = fn
		return fn
	end)
	q_rankloader.hooked_require = true
	print("[q_rankloader]: Hooked require!")
end

if SMODS and not q_rankloader.old_nfs_read then
	q_rankloader.old_nfs_read = NFS.read
	NFS.read = function(path, nS, sN)
		if not path:match("%.lua$") then
			return q_rankloader.old_nfs_read(path, nS, sN)
		end
		if q_rankloader.cache[path] then
			return q_rankloader.cache[path], q_rankloader.cached_sizes[path]
		end
		local content, size = q_rankloader.old_nfs_read(path, nS, sN)
		if not content then
			return content, size
		end
		local fixed = q_rankloader.patch_text(content)
		q_rankloader.cache[path] = fixed
		q_rankloader.cached_sizes[path] = size
		return fixed, size
	end
	print("[q_rankloader]: Hooked NFS.read!")
end
