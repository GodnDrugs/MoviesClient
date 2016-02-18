//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

//let testString = "hello"
//let regexExpression = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpressionOptions.CaseInsensitive)
//let predicate = NSPredicate(format:"SELF MATCHES %@", regexExpression)
//var result = predicate.evaluateWithObject(testString)
//print(result)

let regexExpression = ".*[^A-Za-z0-9].*"

var emailTest = NSPredicate(format:"SELF MATCHES %@", regexExpression)

var result = emailTest.evaluateWithObject("jdhf")

