//
//  File.swift
//  
//
//  Created by Ilya Krupko on 04.11.2022.
//

import ArgumentParser
import Foundation

struct BuilNotesCommand: ParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "buildnotes",
        abstract: "Compiles release notes from different .csv files."
    )

    @Argument(help: "Path to localisation folders")
    var path: String = "/Users/ikrupko/Documents/Crowdin"

    @Argument(help: "Version prefix")
    var versionPrefix: String = "v2.7"

    lazy var englishLocalisation = LocalisationInfo(name: "English", pathPrefix: path + "/" + "")
    lazy var localisations = [
        LocalisationInfo(name: "Chinese", pathPrefix: path + "/" + "zh/"),
        LocalisationInfo(name: "Hindi", pathPrefix: path + "/" + "hi/"),
        LocalisationInfo(name: "Indonesian", pathPrefix: path + "/" + "id/"),
        LocalisationInfo(name: "Malay", pathPrefix: path + "/" + "ms/"),
        LocalisationInfo(name: "Portuguese", pathPrefix: path + "/" + "pt/"),
        LocalisationInfo(name: "Spanish", pathPrefix: path + "/" + "es/"),
        LocalisationInfo(name: "Thai", pathPrefix: path + "/" + "th/"),
        LocalisationInfo(name: "Vietnamese", pathPrefix: path + "/" + "vi/"),
        LocalisationInfo(name: "Turkish", pathPrefix: path + "/" + "tr/")
    ]

    private func shell(command: String) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        task.standardOutput = nil
        task.launch()
        task.waitUntilExit()
    }

    fileprivate func downloadCrowdinFiles() {
        let crowdinAppPath = Constants.crowdinAppPath
        shell(command: "cd \(path) && \(crowdinAppPath) download sources && \(crowdinAppPath) download")
    }

    mutating func run() throws {
        Logger.logEvent("Building release notes using prefix: \(versionPrefix)")

        Logger.logEvent("\n1: Download Crowdin files ---")
        downloadCrowdinFiles()

        Logger.logEvent("\n2: Reading translation files ---")
        _ = englishLocalisation
        _ = localisations

        let releaseKeys = englishLocalisation.getKeys(prefix: versionPrefix)
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
        let filePathWithExtension = path + "/" + "ReleaseNotes_\(versionPrefix).txt"
        try? text.write(toFile: filePathWithExtension, atomically: true, encoding: .utf8)
    }
}
