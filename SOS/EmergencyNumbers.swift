//
//  EmergencyNumbers.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 27..
//

import Foundation

struct Country: Codable{
    var Name: String
    var ISOCode: String
    var ISONumeric: String
}

struct Ambulance: Codable{
    var All: [String?]
}

struct Fire: Codable{
    var All: [String?]
}

struct Police: Codable{
    var All: [String?]
}

struct Dispatch: Codable{
    var All: [String]
}

struct EmergencyNumber: Codable{
    var Country: Country
    var Ambulance: Ambulance
    var Fire: Fire
    var Police: Police
}

struct EmergencyNumbers: Codable{
    var numbers: [EmergencyNumber]
}
