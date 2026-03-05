#!/usr/bin/swift

import Foundation

// Constants
// To get an API Key and Auth Token, refer to https://docs.google.com/document/d/1Fw8tHi1mAWqcmVT8aHWL4jUQHYEYHiBnTi6sqlp7aLs/edit?tab=t.0
let apiKey = ""
let authToken = ""


// Validate input
guard CommandLine.arguments.count >= 2 else {
    printError("Usage: \nrecs_inspector LOGGING_KEY\n or\nrecs_inspector LOGGING_KEY useflag")
    exit(1)
}

// Extract args
let loggingKey = CommandLine.arguments[1]
let useFlag = CommandLine.arguments.contains("useflag")


// Set up url
var url = "https://openapi.etsy.com/etsyapps/v3/bespoke/member/boe-recs-inspector/context-menu?logging_key=\(loggingKey)"
if useFlag {
	url += "&features=listing_tracking.results_cache_writes.hset_recs:off"
}

// Set up command
let command = """
curl --location \"\(url)\" \
--header "x-api-key: \(apiKey)" \
--header "user-agent: Dalvik/2.1.0 (Linux; U; Android 14; SM-F721U1 Build/UP1A.231005.007) Mobile/1 EtsyEnterprise/7.29.0.138 Android/1" \
--header "Authorization: Bearer \(authToken)"
"""

print("running command: \n\(command)\n")

do {
	let result = try shell(command)
	print("result: \(result)")
} catch {
	printError("error: \(error)")
}




// MARK: Funcs
func printError(_ message: String) {
    fputs(message + "\n", stderr)
}

@discardableResult // Add to suppress warnings when you don't want/need a result
func shell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}