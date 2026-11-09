return {
	["Spring Boot Request Mapping"] = {
		prefix = "req",
		body = {
			'@${1|GetMapping,PostMapping,PutMapping,DeleteMapping|}(${2:"/${3:path}"})',
			"public ResponseEntity<${4:ResponseDTO}> ${5:methodName}(",
			"\t${6|@PathVariable UUID id,@RequestParam String param,@RequestBody @Valid RequestDTO request,@PathVariable UUID id\\, @RequestBody @Valid RequestDTO request|}",
			") {",
			"\treturn ResponseEntity.ok(${7:serviceName}.${8:methodName}(${9:id}));",
			"}$0",
		},
		description = "Create a Spring Boot request mapping with choices for HTTP methods and parameter types",
	},
	["Spring Boot Exception Handler"] = {
		prefix = "exh",
		body = {
			"@ExceptionHandler(${1:CustomException}.class)",
			"public ResponseEntity<ErrorResponse> handle${2:CustomException}(",
			"\t${1:CustomException} e) {",
			"\tHttpStatus status = HttpStatus.${1:BAD_REQUEST};",
			"\treturn ResponseEntity.status(status).body(new ErrorResponse(status, e.getMessage()));",
			"}$0",
		},
		description = "Create a Spring Boot @ExceptionHandler method with a choice of HTTP status codes",
	},
}
