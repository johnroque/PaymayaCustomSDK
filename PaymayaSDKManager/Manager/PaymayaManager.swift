//
//  PaymayaManager.swift
//  PaymayaSDKManager
//
//  Created by John Roque Jorillo on 12/27/19.
//  Copyright © 2019 jroque. All rights reserved.
//

import Foundation


public class PayMayaSDK {
    
    public static let shareInstance = PayMayaSDK()
    
    private init() {
    }
    
    public func createPaymentTokenFromCard(card: PayMayaCard, successBlock: @escaping ((PaymayaVaultResponse) -> Void), failureBlock: @escaping ((Error) -> Void)) {
        if paymentManager == nil {
            fatalError(Constants.sdkNotInitialize)
        }
        
        paymentManager?.createPaymentTokenFromCard(card: card, successBlock: successBlock, failureBlock: failureBlock)
    }
    
    public func setPaymentAPIKey(apiKey: String, environment: PayMayaSDKEnvironment) {
        self.environment = environment
        self.paymentManager = MyPayMayaPayAPIManager()
        
        let baseURL = MyPaymayaUtilities.paymentsBaseUrlEnvironment(environment: environment)
        
        paymentManager?.setBaseUrl(baseUrl: baseURL, clientKey: apiKey, clientSecret: "")
    }
    
    private var paymentManager: MyPayMayaPayAPIManager?
    private var environment: PayMayaSDKEnvironment = .sandbox
    
}

internal class MyPayMayaPayAPIManager {
    
    internal func setBaseUrl(baseUrl: String, clientKey: String, clientSecret: String) {
        self.baseUrl = baseUrl
        self.clientKey = clientKey
        self.clientSecret = clientSecret
        
//        let clientKeyScretData = "\(clientKey):\(clientSecret)".base64Encoded!
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = ["Authorization": "Basic \(clientKeyScretData)"]
        
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    internal func createPaymentTokenFromCard(card: PayMayaCard,
                                             successBlock: @escaping ((PaymayaVaultResponse) -> Void), failureBlock: @escaping ((Error) -> Void)) {
        guard let clientKeySecretData = MyPaymayaUtilities.convertToBase64Encoded(value: "\(clientKey):\(clientSecret)") else {
            fatalError(Constants.emptyData)
        }
        
        
        let url = URL(string: "\(baseUrl)\(Constants.paymentTokenUrl)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(card.idempotentKey, forHTTPHeaderField: "Idempotent-Token")
        
        request.setValue("Basic \(clientKeySecretData)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        
        let jsonString = ["card": [
            "number": card.number,
            "expMonth": card.expiryMonth,
            "expYear": card.expiryYear,
            "cvc": card.cvc
            ]]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonString, options: [])
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                
                guard let data = data else {
                    failureBlock(PayMayaBasicError(message: Constants.emptyData))
                    return
                }
                
                if let response = response as? HTTPURLResponse, MyPaymayaUtilities.isResponseOK(response: response) {
                    
                    do {
                        let paymentVaultResponse = try JSONDecoder().decode(PaymayaVaultResponse.self, from: data)
                        successBlock(paymentVaultResponse)
                    } catch {
                        failureBlock(PayMayaBasicError(message: Constants.unableToParse))
                    }
                    
                } else {
                    
                    do {
                        let payMayaError = try JSONDecoder().decode(PayMayaError.self, from: data)
                        failureBlock(payMayaError)
                    } catch {
                        failureBlock(PayMayaBasicError(message: Constants.unableToParse))
                    }
                    
                }
                
            } else {
                failureBlock(PayMayaBasicError(message: error!.localizedDescription))
            }
            
        }
        
        task.resume()
    }
    
    private var baseUrl: String = ""
    private var session: URLSession?
    private var clientKey: String = ""
    private var clientSecret: String = ""
    
}
