//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/16/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	fileprivate let cellId = "cellId"
	fileprivate let headerId = "headerId"
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
	
		
		navigationItem.title = Auth.auth().currentUser?.uid
		fetchUser()
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
		setupLogOutButton()
		
		fetchPost()
		
	}
	
	var posts = [Post]()
	fileprivate func fetchPost() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let databaseRef = Database.database().reference().child("posts").child(uid)
		databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in // allows us to fetch database as string : any
//			print(snapshot.value)
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			dictionary.forEach({ (key, value) in
//				print("key \(key), Value: \(value)")
				guard let dictionary = value as? [String:Any] else { return }
				let post = Post(dictionary: dictionary)
				print(post.imageUrl)
				self.posts.append(post)
			})
			self.collectionView.reloadData()
		}) { (err) in
			print("failed to fetch posts:", err)
		}
	}
	
	fileprivate func setupLogOutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
	}
	
	@objc func handleLogOut() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			do {
				try Auth.auth().signOut()
				
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			} catch let err {
				print("Failed to sign out:", err)
			}
		
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
		
		header.user = self.user
		return header
	}
	
	 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	var user: User?
	fileprivate func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			print(snapshot.value ?? "")
			
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			
			self.user = User(dictionary: dictionary)
			self.navigationItem.title = self.user?.username
			
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch user:", err)
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
		cell.post = posts[indexPath.row]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}
	
}

struct User {
	let username: String
	let profileImageUrl: String
	
	init(dictionary: [String: Any]) {
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}
