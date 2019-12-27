//
//  PaymayaCard.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation

public class PayMayaCard {
    
    var number: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvc: String = ""
    
    public init(number: String, expMonth: String, expYear: String, cvc: String) {
        self.number = number
        self.expiryMonth = expMonth
        self.expiryYear = expYear
        self.cvc = cvc
    }

    var idempotentKey: String {
        let cardInfoString =
            "\(self.number)\(self.expiryMonth)\(self.expiryYear)\(self.cvc)"
        return MyPaymayaUtilities.sha1(value: cardInfoString)
    }
    
}

