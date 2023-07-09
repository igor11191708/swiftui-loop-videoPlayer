//
//  File.swift
//  
//
//  Created by Igor on 09.07.2023.
//

import Foundation

enum VPErrors : Error, CustomStringConvertible{
    
    case fileNotFound(String)
    
    case settingsNotUnique
    
    var description: String{
        switch(self){
            case .fileNotFound(let name) : return "File not found \(name)"
        case .settingsNotUnique : return "Settings are not unique"
            
        }
    }
}
