//
//  PurchaseProductDetails.swift
//  AiTextToSpeech
//
//  Created by henry on 09/05/2025.
//

import Foundation

// Define the product details struct required by the view
struct PurchaseProductDetails: Identifiable {
    var id: String { productId }
    let price: String
    let productId: String
    let duration: String
    let durationPlanName: String
    let priceDurationInfo: String
    
    // Optional properties for additional subscription details
    var subscriptionGroupID: String?
    var localizedDescription: String?
    
    var hasFreeTrial: Bool = false
    var trialPeriod: String? = nil
}
