import ArgumentParser
import Foundation

struct ReleaseHelper: ParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "releasehelper",
        abstract: "Manage release notes in the command line!",
        usage: "releasehelper buildnotes /Users/ikrupko/Documents/Crowdin v2.4",
        version: "1.0.0",
        shouldDisplay: true,
        subcommands: [BuilNotesCommand.self],
        helpNames: .shortAndLong
    )
}
