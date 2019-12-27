//
//  PaymayaConstants.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation

struct Constants {
    
    static let sandboxUrl = "https://pg-sandbox.paymaya.com/payments"
    static let productionUrl = "https://pg.paymaya.com/payments"
    
    static let paymentTokenUrl = "/v1/payment-tokens"
 
    static let sdkNotInitialize = "Payments SDK not initialized."
    
    static let emptyData = "Empty data."
    static let unableToParse = "Unable to parse response."
    
}
