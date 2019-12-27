//
//  PaymayaUtilities.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation
import CommonCrypto

internal class MyPaymayaUtilities {
    
    static func paymentsBaseUrlEnvironment(environment: PayMayaSDKEnvironment) -> String {
        switch environment {
        case .sandbox:
            return Constants.sandboxUrl
        case .production:
            return Constants.productionUrl
        }
    }
    
    static func sha1(value: String) -> String {
        let data = Data(value.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    static func convertToBase64Decoded(value: String) -> String? {
        guard let base64 = Data(base64Encoded: value) else { return nil }
        let utf8 = String(data: base64, encoding: .utf8)
        return utf8
    }
    
    static func convertToBase64Encoded(value: String) -> String? {
        let utf8 = value.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64

    }
    
    static func isResponseOK(response: HTTPURLResponse) -> Bool {
        return (200...299).contains(response.statusCode)
    }

    
}

