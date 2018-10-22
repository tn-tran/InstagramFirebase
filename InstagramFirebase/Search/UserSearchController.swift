//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/21/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
	var user: User?
	let cellId = "cellId"
	var filteredUsers = [User]()
	lazy var searchBar: UISearchBar = {
		let sb = UISearchBar()
		sb.placeholder = "Enter username"
		sb.tintColor = .gray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		sb.delegate = self
		return sb
	}()
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			self.filteredUsers = self.users
		} else {
			self.filteredUsers = self.users.filter { (user) -> Bool in
				
				return user.username.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.collectionView?.reloadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		let navBar = navigationController?.navigationBar
		navigationController?.navigationBar.addSubview(searchBar)
		searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		
		collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
		
		collectionView.alwaysBounceVertical = true
		collectionView.keyboardDismissMode = .onDrag
		
		fetchUsers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		searchBar.isHidden = false
	}
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		searchBar.isHidden = true
		searchBar.resignFirstResponder()
		let user = filteredUsers[indexPath.item]
		print(user.username)
		
		let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
		navigationController?.pushViewController(userProfileController, animated: true)
		
		userProfileController.userId = user.uid
	}
	var users = [User]()
	
	fileprivate func fetchUsers() {
		print("Fetching users...")
		let ref = Database.database().reference().child("users")
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			print(snapshot.value)
			guard let dictionaries = snapshot.value as? [String: Any] else { return }
			dictionaries.forEach({ (key, value) in
				if key  == Auth.auth().currentUser?.uid {
					print("Found myself, omit from list")
					return
				}
				guard let userDictionary = value as? [String: Any] else { return }
				let user = User(uid: key, dictionary: userDictionary)
				self.users.append(user)
				
				
			})
			self.users.sort(by: { (user1, user2) -> Bool in
				return user1.username.compare(user2.username) == .orderedAscending
			})
			self.filteredUsers = self.users
			self.collectionView?.reloadData()
		}) { (err) in
			print("failed to fetch users", err)
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredUsers.count
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
		cell.user = filteredUsers[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 100)
	}
	
}
