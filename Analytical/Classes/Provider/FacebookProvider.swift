//
//  Facebook.swift
//  Application
//
//  Created by Dal Rupnik on 18/07/16.
//  Copyright © 2016 Blub Blub. All rights reserved.
//

import FBSDKCoreKit

public class FacebookProvider : Provider<FBSDKApplicationDelegate>, Analytical {
    
    //
    // MARK: Analyical
    //
    
    public func setup(properties: Properties?) {
        instance = FBSDKApplicationDelegate.sharedInstance()
        
        if let launchOptions = properties?[Property.Launch.Options.rawValue] as? [NSObject: AnyObject], application = properties?[Property.Launch.Application.rawValue] as? UIApplication {
            instance.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    public override func activate() {
        FBSDKAppEvents.activateApp()
    }
    
    public func flush() {
        FBSDKAppEvents.flush()
    }
    
    public func reset() {
        //
        // No way to reset user properties with Facebook
        //
    }
    
    public override func event(name: EventName, properties: Properties?) {
        FBSDKAppEvents.logEvent(name, parameters: properties)
    }
    
    public func screen(name: EventName, properties: Properties?) {
        event(name, properties: properties)
    }
    
    public func identify(userId: String, properties: Properties?) {
        //
        // No user tracking with Facebook
        //
    }
    
    public func alias(userId: String, forId: String) {
        //
        // No alias tracking with Facebook
        //
    }
    
    public func set(properties: Properties) {
        //
        // No custom properties
        //
    }
    
    public func increment(property: String, by number: NSDecimalNumber) {
        FBSDKAppEvents.logEvent(property, valueToSum: number.doubleValue)
    }
    
    public func purchase(amount: NSDecimalNumber, properties: Properties?) {
        let properties = prepareProperties(properties)
        
        let currency = properties[Property.Purchase.Currency.rawValue] as? String
        
        var finalParameters : [String : AnyObject] = [:]
        finalParameters[FBSDKAppEventParameterNameContentType] = properties[Property.Category.rawValue] as? String
        finalParameters[FBSDKAppEventParameterNameContentID] = properties[Property.Purchase.Sku.rawValue] as? String
        finalParameters[FBSDKAppEventParameterNameCurrency] = currency
        
        FBSDKAppEvents.logPurchase(amount.doubleValue, currency: currency, parameters: finalParameters)
    }
    
    private func prepareProperties(properties: Properties?) -> Properties {
        var currentProperties : Properties! = properties
        
        if currentProperties == nil {
            currentProperties = [:]
        }
        
        return currentProperties
    }
}