//
//  PaymayaBasicError.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation

public struct PayMayaBasicError: Swift.Error, LocalizedError {
    var message: String
    
    public var errorDescription: String? {
        return message
    }
}
