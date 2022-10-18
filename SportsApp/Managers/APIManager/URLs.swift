//
//  URLs.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 15/10/2022.
//

import Foundation

enum EndPoints {
    
    static let base = "http://api.football-data.org"

    //  App-Auth Facebook
    case getComtetions
    case getComtetionsDetails
    case getTeams
    
    
    
    var stringValue: String {
        
        switch self {
        
        case .getComtetions:
            return EndPoints.base + "/v2/competitions"
            
        case .getComtetionsDetails:
            return EndPoints.base + "/v2/competitions/"
            
        case .getTeams:
            return EndPoints.base + "/v2/teams/"
            
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
