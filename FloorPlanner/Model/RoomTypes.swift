//
//  RoomTypes.swift
//  HomeDecorAi
//
//  Created by henry on 26/08/2025.
//




enum RoomType: String, CaseIterable {
    case livingRoom
    case bedroom
    case kitchen
    case diningRoom
    case bathroom
    case homeOffice
    case hallway
    case toilet
    case kidsRoom
    case guestRoom
    case basement
    case attic
    case outdoorPatio
    case balcony
    case entryway
    case laundryRoom
    case gamingRoom
    case studyRoom
}

extension RoomType {
        
    var localizedName: String {
        switch self {
            
        case .livingRoom: return String(localized: "Living Room")
        case .bedroom: return String(localized: "Bedroom")
        case .kitchen: return String(localized: "Kitchen")
        case .diningRoom: return String(localized: "Dining Room")
        case .bathroom: return String(localized: "Bathroom")
        case .homeOffice: return String(localized: "Home Office")
        case .hallway: return String(localized: "Hallway")
        case .toilet: return String(localized: "Toilet")
        case .kidsRoom: return String(localized: "Kids Room")
        case .guestRoom: return String(localized: "Guest Room")
        case .basement: return String(localized: "Basement")
        case .attic: return String(localized: "Attic")
        case .outdoorPatio: return String(localized: "Outdoor Patio")
        case .balcony: return String(localized: "Balcony")
        case .entryway: return String(localized: "Entryway")
        case .laundryRoom: return String(localized: "Laundry Room")
        case .gamingRoom: return String(localized: "Gaming Room")
        case .studyRoom: return String(localized: "Study Room")
            
            
        }
    }
    
    var icon:String {
        switch self {
            
        case .livingRoom:
            return "sofa.fill"
        case .bedroom:
            return "bed.double.fill"
        case .kitchen:
            return "frying.pan.fill"
        case .diningRoom:
            return "table.furniture"
        case .bathroom:
            return "shower.fill"
        case .homeOffice:
            return "chair"
        case .hallway:
            return "door.left.hand.open"
        case .kidsRoom:
            return "teddybear.fill"
        case .guestRoom:
                return "chair.lounge.fill"
        case .basement:
            return "door.garage.closed"
        case .attic:
            return "window.ceiling"
        case .outdoorPatio:
            return "fireplace"
        case .balcony:
            return "window.horizontal"
        case .entryway:
            return "door.french.open"
        case .laundryRoom:
            return "washer.fill"
        case .gamingRoom:
            return "gamecontroller.fill"
        case .studyRoom:
            return "books.vertical.fill"
        case .toilet:
            return "toilet.fill"

        }
    }
}
