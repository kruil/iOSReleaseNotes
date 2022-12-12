//
//  File.swift
//  
//
//  Created by Ilya Krupko on 03.11.2022.
//

import Foundation

final class LocalisationInfo {

    struct Translation {
        let key: String
        let value: String
    }

    let name: String
    let pathLanguageCode: String
    var pathToSourceFile: String { Settings.sourceFilesPath + "/" + pathLanguageCode + "/" + Settings.sourceFileName }
    var translations = [Translation]()

    init(_ language: Language) {
        self.name = language.name
        self.pathLanguageCode = language.pathLanguageCode
        readFileToDictionary(pathToSourceFile)
    }

    func readFileToDictionary(_ path: String) {
        let translationIndex = name == "English" ? 1 : 2
        guard let text = try? String(contentsOfFile: path) else {
            Logger.logError("Error! Can't find file for \(name): \(path)")
            return
        }
        let lines = text.split(separator: "\n")
        for line in lines {
            let parts: [String] = line.dropFirst().dropLast().components(separatedBy: "\",\"")
            guard parts.count == 3 else { continue }
            let key = parts[0]
            let value = parts[translationIndex]
            guard !value.isEmpty else { continue }
            translations.append(.init(key: key, value: value))
        }
        Logger.logEvent("✓ \(name)")
    }

    func getKeys(prefix: String) -> [String] {
        var result = ["GeneralPhrase"]
        let features = translations.filter { $0.key.starts(with: prefix) }.map { $0.key }
        result.append(contentsOf: features)
        result.append("LastPhrase")
        return result
    }

    func getReleaseNotes(keys: [String]) -> String? {
        var result = ""
        for key in keys {
            guard let translation = translations.first(where: { $0.key == key })?.value else {
                return nil
            }
            result += translation + "\n"
        }
        return result
    }
}
