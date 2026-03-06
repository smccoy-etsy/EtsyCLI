#!/usr/bin/swift

import Foundation
import Darwin

// MARK: Shell
func printError(_ message: String) {
    fputs(message + "\n", stderr)
}

@discardableResult
func shell(
    _ command: String,
    printCommand: Bool = false,
    printOutput: Bool = false,
    waitUntilExit: Bool = false
) throws -> String {
    
    if printCommand {
        print(command)
    }


    let process = Process()
    let pipe = Pipe()
    
    process.standardOutput = pipe
    process.standardError = pipe
    process.arguments = ["-c", command]
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.standardInput = nil

    try process.run()
    if waitUntilExit {
        process.waitUntilExit()
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    if (printOutput) {
        print(output)
    }
    
    return output
}

// Note: This swaps the active process to ssh, ending the script.
func replaceProcessWithInteractiveSSH(host: String, remoteCommand: String? = nil) {

    printColor("SSHing to \(host)...")

    let ssh = "/usr/bin/ssh"
    var args = [ssh, "-tt", host]

    if let remoteCommand {
        let remoteCommandPlusShell = remoteCommand + "; exec $SHELL -l"
        args.append(remoteCommandPlusShell)
    }

    var cargs: [UnsafeMutablePointer<CChar>?] = args.map { strdup($0) }
    cargs.append(nil)
    defer { for p in cargs where p != nil { free(p) } }

    execvp(ssh, &cargs)
    perror("execvp failed")
    
    printColor("SSH connection to \(host) ended", .red)
    
    exit(1)
}

enum ShellTextColor: String, CaseIterable {
    case reset = "\u{001B}[0m"

    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"

    case blackBold = "\u{001B}[1;30m"
    case redBold = "\u{001B}[1;31m"
    case greenBold = "\u{001B}[1;32m"
    case yellowBold = "\u{001B}[1;33m"
    case blueBold = "\u{001B}[1;34m"
    case magentaBold = "\u{001B}[1;35m"
    case cyanBold = "\u{001B}[1;36m"
    case whiteBold = "\u{001B}[1;37m"

    case blackFaded = "\u{001B}[2;30m"
    case redFaded = "\u{001B}[2;31m"
    case greenFaded = "\u{001B}[2;32m"
    case yellowFaded = "\u{001B}[2;33m"
    case blueFaded = "\u{001B}[2;34m"
    case magentaFaded = "\u{001B}[2;35m"
    case cyanFaded = "\u{001B}[2;36m"
    case whiteFaded = "\u{001B}[2;37m"

    case blackUnderlined = "\u{001B}[4;30m"
    case redUnderlined = "\u{001B}[4;31m"
    case greenUnderlined = "\u{001B}[4;32m"
    case yellowUnderlined = "\u{001B}[4;33m"
    case blueUnderlined = "\u{001B}[4;34m"
    case magentaUnderlined = "\u{001B}[4;35m"
    case cyanUnderlined = "\u{001B}[4;36m"
    case whiteUnderlined = "\u{001B}[4;37m"

    case blackFlashing = "\u{001B}[5;30m"
    case redFlashing = "\u{001B}[5;31m"
    case greenFlashing = "\u{001B}[5;32m"
    case yellowFlashing = "\u{001B}[5;33m"
    case blueFlashing = "\u{001B}[5;34m"
    case magentaFlashing = "\u{001B}[5;35m"
    case cyanFlashing = "\u{001B}[5;36m"
    case whiteFlashing = "\u{001B}[5;37m"
}

func printColor(_ message: String, terminator: String = "\n", _ color: ShellTextColor = .green) {
    print("\(color.rawValue)\(message)\(ShellTextColor.reset.rawValue)", terminator: terminator)
}

@discardableResult
func prompt(_ text: String, color: ShellTextColor = .yellow) -> String {
    printColor(text, terminator: " ", color)
    return readLine() ?? ""
}

func promptYes(_ text: String, color: ShellTextColor = .yellow) -> Bool {
    printColor(text, terminator: " ", color)
    printColor("Press y/Y to accept, any other key to skip", terminator: " ", color)
    let response = readLine() ?? ""

    guard response == "y" || response == "Y" else {
        return false
    }

    return true
}

func promptYesWithTimeout(
    _ text: String, 
    timeout: TimeInterval = 3.0, 
    color: ShellTextColor = .yellow
) -> Bool {


    let semaphore = DispatchSemaphore(value: 0)
    var userInput: String?

    printColor(text, terminator: " ", color)
    printColor("Press y/Y to accept, any other key to skip. You have \(timeout) seconds to respond.", terminator: " ", color)
    fflush(stdout) // Ensure prompt prints immediately

    // 1. Read input on a background thread
    DispatchQueue.global().async {
        userInput = readLine()
        semaphore.signal() // Signal that input was received
    }

    // 2. Wait for input or timeout
    let result = semaphore.wait(timeout: .now() + timeout)

    if result == .timedOut {
        // Clear the input line
        print("")
        return false
    }

    guard userInput == "y" || userInput == "Y" else {
        return false
    }

    return true

}


// MARK: funcs
func gcloudAuth(attemptNumber: Int = 1) throws {

    if attemptNumber == 2 {
        printColor("Could not authenticate with gcloud!", .red)
    }

    // Note: use `gcloud auth revoke` to test logging out
    printColor("Checking gcloud status...")
    let gcloudAuthResult = try shell("gcloud auth list")

    if gcloudAuthResult.contains("Credentialed Accounts") {
        printColor("Logged in to gcloud!")
        return
    }

    printColor("Re-authenticating with gcloud...", .red)
    try shell("gcloud auth login --update-adc")

    try gcloudAuth(attemptNumber: attemptNumber + 1)
}

func getVmInfo() throws -> (String, String) {
    printColor("Gathering VM info...")
    let etsywebctlOutput = try shell("etsywebctl vm list | tail -1")
    let vmInfo = etsywebctlOutput.split(separator: " ").map { String($0) }

    guard vmInfo.count >= 2 else {
        printColor("Could not extract VM info! etsywebctl output: \n\(etsywebctlOutput)", .red)
        exit(1)
    }

    let vmName = vmInfo[0].trimmingCharacters(in: .whitespacesAndNewlines)
    let vmUrl = vmInfo[1].trimmingCharacters(in: .whitespacesAndNewlines)

    // Validate
    [vmName, vmUrl].forEach {
        guard $0.count > 0 else {
            printColor("Could not extract VM info! etsywebctl output: \n\(etsywebctlOutput)", .red)
            exit(0)
        }
    }

    printColor("Your vm is named [\(vmName)] and located at [\(vmUrl)]")

    return (vmName, vmUrl)
}

func isVPNConnected() throws -> Bool {
    let output = try shell("osascript -e \'tell application \"Viscosity\" to return state of (connections where name is \"Etsy Prod VPN Okta\")\'")

    if output.contains("Connected") {
        printColor("Connected to VPN!")
        return true
    }

    return false
}


func waitForVPNConnected(attemptNumber: Int = 1) throws {
    guard attemptNumber < 20 else {
        printColor("Could not connect to VPN!", .red)
        exit(1)
    }

    guard try isVPNConnected() else {
        Thread.sleep(forTimeInterval: 0.5)
        try waitForVPNConnected(attemptNumber: attemptNumber + 1)
        return
    }
}

func connectToVPN() throws {
    if try isVPNConnected() {
        return
    }

    try shell("osascript -e \'tell application \"Viscosity\" to connect \"Etsy Prod VPN Okta\"\'")
    try waitForVPNConnected()
}

// MARK: Script
try gcloudAuth()
let (vmName, vmUrl) = try getVmInfo()
try connectToVPN()

let httpsVmUrl = "https://\(vmUrl)"
if promptYesWithTimeout("Open Chrome to your VM page [\(httpsVmUrl)]?") {
    try shell("open -a \"Google Chrome\" \"\(httpsVmUrl)\"")
} else {
    printColor("Not opening Chrome.")
}

replaceProcessWithInteractiveSSH(host: vmUrl, remoteCommand: "cd development/Etsyweb/")