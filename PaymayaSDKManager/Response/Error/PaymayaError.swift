//
//  PaymayaError.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation

public struct PayMayaError: Codable {
    
    var message: String?
    var parameters: [Parameter]?
    
    struct Parameter: Codable {
        let description: String
    }
    
    func getErrorMessage() -> String {
        
        if let parameters = parameters {
            var lines: [String] = []
            for paramter in parameters {
                lines.append("\(paramter.description)")
            }
            lines.append("\n")
            
            if let message = message {
                return "\(message)\n\(lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))"
            } else {
                return "\(lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))"
            }
            
        }
        
        if let message = message {
            return message
        }
        
        return ""
    }
    
}

extension PayMayaError: Swift.Error, LocalizedError {
    public var errorDescription: String? {
        return self.getErrorMessage()
    }
}

