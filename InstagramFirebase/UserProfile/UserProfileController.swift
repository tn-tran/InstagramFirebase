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

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
	func didChangeToListView() {
		isGridView = false
		collectionView.reloadData()
	}
	
	func didChangeToGridView() {
		isGridView = true
		collectionView.reloadData()
	}
	
	var isGridView = true
	
	fileprivate let cellId = "cellId"
	fileprivate let headerId = "headerId"
	fileprivate let homePostCellId = "homePostCellId"
	var userId: String?
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		
		
		
		
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
		setupLogOutButton()
		fetchUser()
		//		fetchOrderedPost()
	}
	
	fileprivate func fetchOrderedPost() {
		guard let uid =  self.user?.uid else { return }
		
		let databaseRef = Database.database().reference().child("posts").child(uid)
		// maybe implement some paganation of data
		databaseRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			//			print(snapshot.key, snapshot.value)
			guard let user = self.user else { return }
			let post = Post(user: user, dictionary: dictionary)
			self.posts.insert(post, at: 0)
			//			self.posts.append(post)
			self.collectionView?.reloadData()
		}) { (err) in
			print("Failed to fetch ordered posts:", err)
		}
	}
	
	var posts = [Post]()
	//	fileprivate func fetchPost() {
	//		guard let uid = Auth.auth().currentUser?.uid else { return }
	//		let databaseRef = Database.database().reference().child("posts").child(uid)
	//		databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in // allows us to fetch database as string : any
	////			print(snapshot.value)
	//			guard let dictionary = snapshot.value as? [String: Any] else { return }
	//			dictionary.forEach({ (key, value) in
	////				print("key \(key), Value: \(value)")
	//				guard let dictionary = value as? [String:Any] else { return }
	//				let post = Post(dictionary: dictionary)
	//				print(post.imageUrl)
	//				self.posts.append(post)
	//			})
	//			self.collectionView.reloadData()
	//		}) { (err) in
	//			print("failed to fetch posts:", err)
	//		}
	//	}
	
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
		header.delegate = self
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	var user: User?
	fileprivate func fetchUser() {
		let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
		print(uid)//		guard let uid = Auth.aut  h().currentUser?.uid else { return }
		
		Database.fetchUserWithUID(uid: uid) { (user) in
			
			self.user = user
			self.navigationItem.title = self.user?.username
			
			self.collectionView?.reloadData()
			self.fetchOrderedPost()
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if isGridView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
			cell.post = posts[indexPath.row]
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
			cell.post = posts[indexPath.row]
			return cell
		}

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if isGridView {
			let width = (view.frame.width - 2) / 3
			return CGSize(width: width, height: width)
		} else {
			var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
			height += view.frame.width
			height += 50 // for the buttons
			height += 70 // for textCaption
			return CGSize(width: view.frame.width, height: height)
			
			
		}
		
	}
}

