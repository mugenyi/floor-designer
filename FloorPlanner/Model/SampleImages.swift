//
//  SampleImages.swift
//  HomeDecorAi
//
//  Created by henry on 28/08/2025.
//


enum SampleImages: String,CaseIterable {
    case livingRoom
    case bedroom
    case kitchen
    case diningRoom
    case bathroom
    
    var localizedName:String {
        switch self {
            
        case .livingRoom:
            return String(localized: "Living Room")
        case .bedroom:
            return String(localized: "Bedroom")
        case .kitchen:
            return String(localized: "Kitchen")
        case .diningRoom:
            return String(localized: "Dining Room")
        case .bathroom:
            return String(localized: "Bathroom")
        }
    }
}
