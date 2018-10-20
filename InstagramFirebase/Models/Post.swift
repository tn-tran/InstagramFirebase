//
//  Post.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
struct Post {
	let user: User
	let imageUrl: String
	let caption: String
	
	init(user: User, dictionary: [String:Any]) {
		self.user = user
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
		self.caption = dictionary["caption"] as? String ?? ""
	}
	
}
