//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/23/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
struct Comment {
	let user: User
	let text: String
	let uid: String
	
	init(user: User, dictionary: [String:Any]) {
		self.text = dictionary["text"] as? String ?? ""
		self.uid = dictionary["text"] as? String ?? ""
		self.user = user
	}
}
