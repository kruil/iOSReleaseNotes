//
//  File 2.swift
//  
//
//  Created by Ilya Krupko on 04.11.2022.
//

import Foundation

enum Settings {

    // 0. Install Crowdin CLI https://developer.crowdin.com/cli-tool/ , test that crowdin command in SLI could be found.

    // 1. Create and set here path to folder, where source files stored and your releaseNotes.txt would be generated
    static let sourceFilesPath: String = "/Users/ikrupko/Documents/ReleaseNotes"

    // 2. Copy and paste crowdin.yaml file for this repository to folder above

    // 3. Set version prefix which is used to build release notes
    static let versionPrefix: String = "v2.7"

    // 4. Run project and find generated file named releaseNotes_VERSION.txt in sourceFilesPath


    // MARK: - Don't change everything below

    // Path to crowdinCLI executable
    static let crowdinAppPath = "/usr/local/opt/crowdin@3/bin/crowdin"

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
