import ArgumentParser
import Foundation

struct ReleaseHelper: ParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "releasehelper",
        abstract: "Manage release notes in the command line!",
        usage: "releasehelper buildnotes /Users/ikrupko/Documents/Crowdin v2.4",
        version: "1.0.0",
        shouldDisplay: true,
        helpNames: .shortAndLong
    )

    lazy var englishLocalisation = LocalisationInfo(Settings.mainLanguage)

    lazy var localisations = Settings.languages.map { LocalisationInfo($0) }

    private func shell(command: String) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        task.standardOutput = nil
        task.launch()
        task.waitUntilExit()
    }

    private func downloadCrowdinFiles() {
        let crowdinAppPath = Settings.crowdinAppPath
        shell(command: "cd \(Settings.sourceFilesPath) && \(crowdinAppPath) download sources && \(crowdinAppPath) download")
    }

    mutating func run() throws {
        Logger.logEvent("Building release notes using prefix: \(Settings.versionPrefix)")

        Logger.logEvent("\n1: Download Crowdin files ---")
        downloadCrowdinFiles()

        Logger.logEvent("\n2: Reading translation files ---")
        _ = englishLocalisation
        _ = localisations

        let releaseKeys = englishLocalisation.getKeys(prefix: Settings.versionPrefix)
        guard let englishReleaseNotes = englishLocalisation.getReleaseNotes(keys: releaseKeys) else {
            Logger.logError("Error! Can't create default release notes in English.")
            return
        }

        Logger.logEvent("\n3: Compiling release notes ---")
        var result = ""
        // English
        result = "\(englishLocalisation.name):\n\n" + englishReleaseNotes
        Logger.logEvent("✓ \(englishLocalisation.name)")
        // Other languages
        for localisation in localisations {
            let releaseNotes = localisation.getReleaseNotes(keys: releaseKeys)
            if releaseNotes == nil {
                Logger.logError("Can't find all keys for \(localisation.name), using English instead.")
            } else {
                Logger.logEvent("✓ \(localisation.name)")
            }
            result = result + "\n\n\(localisation.name):\n\n" + (releaseNotes ?? englishReleaseNotes)
        }
        saveToFile(result)
    }

    func saveToFile(_ text: String) {
        let filePathWithExtension = Settings.sourceFilesPath + "/" + "ReleaseNotes_\(Settings.versionPrefix).txt"
        try? text.write(toFile: filePathWithExtension, atomically: true, encoding: .utf8)
    }
}
