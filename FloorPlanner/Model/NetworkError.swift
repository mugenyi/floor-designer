//
//  NetworkError.swift
//  AnimeMaker
//
//  Created by henry on 07/01/2025.
//

import Foundation

enum NetworkError : Error, LocalizedError {
    case InvalidURL
    case invalidResponse
    case InvalidData
    case InvalidRequest
    case NoNetwork
    case SaveFailed
  
    
    var errorDescription: String? {
        switch self {
        case .InvalidURL:
            return String(localized: "Invalid URL")
        case .invalidResponse:
            return String(localized: "The servers failed to create image,  please try again")
        case .InvalidData:
            return String(localized:"The servers failed to create image,  please try again")
        case .InvalidRequest:
            return String(localized: "The servers failed to create image,  please try again")
        case .NoNetwork:
            return  String(localized: "No network was detected. Connect to wi-fi or cellular and try again")
        case .SaveFailed:
            return String(localized:"Failed to save Image, Please Try Again")
        }
    }
  
}

