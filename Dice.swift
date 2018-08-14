//
//  Dice.swift
//  Declinables
//
//  Created by Micah Hansonbrook on 4/22/17.
//  Copyright © 2017-2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import GameKit

/**
 Calculates die rolls for any number of provided sides. Variables representing common die are included for conveniance. A random boolean value can also be generated.
 */
public struct Dice{
    public init(){}
    public func rollD(_ number: Int) -> Int{
        let simulatedDice = GKRandomDistribution(forDieWithSideCount: number)
        return simulatedDice.nextInt()
    }
    public var d4: Int{ get{ return rollD(4)}}
    public var d6: Int{ get{ return rollD(6)}}
    public var d8: Int{ get{ return rollD(8)}}
    public var d10: Int{ get{ return rollD(10)}}
    public var d12: Int{ get{ return rollD(12)}}
    public var d20: Int{ get{ return rollD(20)}}
    public var nextBool: Bool{ get{ if rollD(2) == 1{return true} else {return false}}}
}

