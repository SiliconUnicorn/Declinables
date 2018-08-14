//
//  String Extended.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/3/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

extension String{
    func removeMacrons() -> String{
        var iteration = 0
        var replacement = ""
        for char in self{
            switch char.description{
            case "ā": replacement += "a"
            case "ē": replacement += "e"
            case "ī": replacement += "i"
            case "ō": replacement += "o"
            case "ū": replacement += "u"
            default: replacement += char.description
            }
            iteration += 1
        }
        return replacement
    }
}
