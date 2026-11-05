return {
	["Insert Comment Tag"] = function()
		local comment_string = vim.bo.commentstring
		if comment_string == "" then
			comment_string = "// %s"
		end
		vim.notify(comment_string)

		local comment = "${1|TODO,BUG,FIXME,NOTE,HACK,WARN,INFO,PERF,TEST,REFACTOR|}: $0"

		local body_string
		if string.find(comment_string, "%s", 0, true) then
			body_string = comment_string:format(comment)
		else
			body_string = comment_string .. " " .. comment
		end

		return {
			prefix = "todo",
			body = body_string,
			description = "Insert an interactive comment tag (TODO, BUG, FIXME, etc.)",
		}
	end,
}
