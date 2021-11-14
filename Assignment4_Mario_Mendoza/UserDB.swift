//
//  UserDB.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/25/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import Foundation

class UserDB{
    var user : Array<User>
    var currentUser: Int
   // let defaults = UserDefaults.standard
    
    init() {
        user = Array<User>()
        currentUser = 0
    }
    
    func userAtIndex(_ idx: Int) -> User{
        return user[idx]
    }
//    func sortedUserAtIndex(_ idx: Int) -> User{
//        let sorted = user.sort{$0.getTopSCore() > $1.getTopScore()}
//    }
    func sortedUserAtIndex(_ idx: Int) -> User{
        let sorteduser: [User] = user.sorted(by: {$0.topScore > $1.topScore})
        return sorteduser[idx]
    }
    func count() -> Int{
        return user.count
    }
    
    func addUser(_ u: User){
        user.append(u)
    }
    
    func setCurrentUser(_ idx: Int){
        currentUser = idx
    }
    
    func getCurrentUser() -> User{
        return userAtIndex(currentUser)
    }
    
    func getIndexOfUser(_ u: User) -> Int{
        if let result = user.firstIndex(where: {$0.fullName() == u.fullName()}){
            return result
        }
        else{
            return 0
        }
    }
}
