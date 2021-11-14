//
//  User.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/25/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding{
    
    var speeds: [Double]
    var attempts: [Double: Int]
    var firstName: String
    var lastName: String
    var topScore: Double
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(speeds, forKey: "speed")
        aCoder.encode(attempts, forKey: "attempts")
        aCoder.encode(firstName, forKey: "first")
        aCoder.encode(lastName, forKey: "last")
        aCoder.encode(topScore, forKey: "score")
    }
    required init(coder aDecoder: NSCoder) {
        speeds = aDecoder.decodeObject(forKey: "speed") as! [Double]
        attempts = aDecoder.decodeObject(forKey: "attempts") as! [Double: Int]
        firstName = aDecoder.decodeObject(forKey: "first") as! String
        lastName = aDecoder.decodeObject(forKey: "last") as! String
        topScore = aDecoder.decodeObject(forKey: "score") as? Double ?? 0.0
    }
    
    init(firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        speeds = Array<Double>()
        attempts = [:]
        topScore = 0.0
    }
    
    func fullName() -> String{
        return firstName + " " + lastName
    }
    func setName(_ first: String, _ last: String){
        firstName = first
        lastName = last
    }
    
    func count() -> Int {
        return attempts.count
    }
    
    func addAttempt(speed:Double){
        speeds.append(speed)
        setTopScore()
        if let _ = attempts[speed]{
            attempts[speed]! += 1
        }else{
            attempts[speed] = 1
        }
        //setTopScore()
    }
    
    func getTopThree() -> [Double]{
        let range = min(attempts.count, 3)
        var results : [Double] = []
        let t3 = Array(attempts.keys.sorted(by: >))[0..<range]
        for i in 0..<range{
            results.append(t3[i])
        }
        return results
    }
    func setTopScore(){
        let results : Double = speeds.sorted(by: >).first!
        topScore = results
    }
    
    func getTopScore() -> Double{
        let results : Double = attempts.keys.sorted(by: >).first!
        return results
    }
    
}
