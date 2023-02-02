//
//  User.swift
//  TwitterClone
//
//  Created by Berk Kaya on 3.01.2023.
//

import Foundation
import Firebase

struct User {
    let fullname: String
    let email: String
    let username: String
    let uid:String
    var profileImageUrl : URL?
    var isFollowed = false
    var stats: UserRelationStats?
    
    var isCurrentUser:Bool{
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid:String,dictionary:[String:AnyObject]){
        //We don't excess to uid in dictionary elements section so we have to find that seperetaly
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let profileImageUrlString =  dictionary["profileImageUrl"] as? String{
            guard let url = URL(string: profileImageUrlString) else{ return}
            self.profileImageUrl = url
        }
        
    }
}

struct UserRelationStats {
    var followers:Int
    var following:Int
}
