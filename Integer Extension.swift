//
//  Integer Extension.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/1/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

extension BinaryInteger {
    ///Returns true whenever the integer is even, otherwise it will return false
    var isEven: Bool { return self % 2 == 0 }
    
    ///Returns true whenever the integer is odd, otherwise it will return false
    var isOdd: Bool { return self % 2 != 0 }
}
