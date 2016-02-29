//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return !isEven
    }
}

let num = 5
num.isEven
