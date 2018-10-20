//
//  User.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation

struct User {
	let username: String
	let profileImageUrl: String
	let uid: String
	
	init(uid: String, dictionary: [String: Any]) {
		self.uid = uid
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
		
	}
}
