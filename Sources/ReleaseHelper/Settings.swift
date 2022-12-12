//
//  File 2.swift
//  
//
//  Created by Ilya Krupko on 04.11.2022.
//

import Foundation

enum Settings {

    /// Path to crowdinCLI executable
    static let crowdinAppPath = "/usr/local/opt/crowdin@3/bin/crowdin"

    /// Path to sources folder with crowdin.yml in root
    static let sourceFilesPath: String = "/Users/ikrupko/Documents/Crowdin"

    /// Version prefix which is used to build release notes
    static let versionPrefix: String = "v2.7"

    // MARK: -

    static let sourceFileName = "ReleaseNotes.csv"

    static let mainLanguage = Language(name: "English", pathLanguageCode: "")

    // Sorting is aligned with App Store
    static let languages: [Language] = [
        .init(name: "Chinese", pathLanguageCode: "zh"),
        .init(name: "Hindi", pathLanguageCode: "hi"),
        .init(name: "Indonesian", pathLanguageCode: "id"),
        .init(name: "Malay", pathLanguageCode: "ms"),
        .init(name: "Portuguese", pathLanguageCode: "pt"),
        .init(name: "Spanish", pathLanguageCode: "es"),
        .init(name: "Thai", pathLanguageCode: "th"),
        .init(name: "Vietnamese", pathLanguageCode: "vi"),
        .init(name: "Turkish", pathLanguageCode: "tr")
    ]
}
