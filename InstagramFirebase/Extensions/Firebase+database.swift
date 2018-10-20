//
//  Firebase+database.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import Firebase
extension Database {
	static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
		print("fetching user with uid", uid)
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			guard let userDictionary = snapshot.value as? [String: Any] else {return}
			let user = User(uid: uid,dictionary: userDictionary)
			print(user.username)
			completion(user)
		}) { (err) in
			print("Failed to fetch user for post:", err)
		}
		
	}
}
