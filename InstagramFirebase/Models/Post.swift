//
//  Post.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
struct Post {
	let imageUrl: String
	
	init(dictionary: [String:Any]) {
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
	}
	
}
