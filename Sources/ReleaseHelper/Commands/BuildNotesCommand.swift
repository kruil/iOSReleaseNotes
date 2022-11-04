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
    var versionPrefix: String = "v2.6"

    lazy var sourceLocalisation = LocalisationInfo(name: "English", pathPrefix: path + "/" + "")
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

    mutating func run() throws {
        var result = ""
        let releaseKeys = sourceLocalisation.getKeys(prefix: "v2.6.0_")
        guard let sourceReleaseNotes = sourceLocalisation.getReleaseNotes(keys: releaseKeys) else {
            print("Error! Can't create release notes for English.")
            return
        }
        result = "\(sourceLocalisation.name):\n\n" + sourceReleaseNotes
        // Other localisations
        for localisation in localisations {
            let releaseNotes = localisation.getReleaseNotes(keys: releaseKeys) ?? sourceReleaseNotes
            result = result + "\n\n\(localisation.name):\n\n" + releaseNotes
        }
        saveTextToFile(result)
    }

    func saveTextToFile(_ text: String) {
        let filePathWithExtension = path + "/" + "ReleaseNotes_\(versionPrefix).txt"
        try? text.write(toFile: filePathWithExtension, atomically: true, encoding: .utf8)
    }
}
