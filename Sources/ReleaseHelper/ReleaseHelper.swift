import ArgumentParser
import Foundation

struct ReleaseHelper: ParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Manage release notes in the command line!",
        version: "1.0.0",
        shouldDisplay: true,
        subcommands: [],
        helpNames: .shortAndLong
    )

    @Argument(help: "Version number")
    var version: String

    mutating func run() throws {
        let filePathWithExtension = "ReleaseNotes_\(version).txt"
        do {
            try "Nothing so far".write(toFile: filePathWithExtension, atomically: true, encoding: .utf8)
        } catch {
            throw RuntimeError("Couldn't write to file!")
        }
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    init(_ description: String) {
        self.description = description
    }
}
