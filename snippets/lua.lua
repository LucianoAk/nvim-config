return {
	["Create Snippet"] = {
		prefix = "newsnippet",
		body = {
			'["${1:Snippet Title}"] = {',
			'\tprefix = "${2:trigger_word}",',
			"\tbody = {",
			'\t\t"${3:Line one}"',
			"\t},",
			'\tdescription = "${4:Description of what this snippet does}"',
			"},$0",
		},
		description = "Generate a template for a new snippet",
	},
}
