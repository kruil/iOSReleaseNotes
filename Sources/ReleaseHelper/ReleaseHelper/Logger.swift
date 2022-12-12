//
//  Logger.swift
//  
//
//  Created by Ilya Krupko on 05.12.2022.
//

import Foundation

enum Logger {

    static func logEvent(_ message: String) {
        print(message)
    }

    static func logError(_ message: String) {
        print("🚨 " + message)
    }
}
