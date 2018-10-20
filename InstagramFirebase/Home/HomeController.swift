//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	let cellId = "cellId"
	var posts = [Post]()
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
		setupNavigationItems()
		fetchPost()
		
	}
	
	fileprivate func setupNavigationItems() {
		navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysOriginal))
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
		cell.post = posts[indexPath.item]
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
		height += view.frame.width
		height += 50 // for the buttons
		height += 70 // for textCaption
		return CGSize(width: view.frame.width, height: height)
	}
	
	
	fileprivate func fetchPost() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Database.fetchUserWithUID(uid: uid) { (user) in
			self.fetchPostsWithUser(user: user)
		}
	}
	
	fileprivate func fetchPostsWithUser(user: User) {
		let databaseRef = Database.database().reference().child("posts").child(user.uid)
		databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in // allows us to fetch database as string : any
			//			print(snapshot.value)
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			dictionary.forEach({ (key, value) in
				//				print("key \(key), Value: \(value)")
				guard let dictionary = value as? [String:Any] else { return }
				let post = Post(user: user, dictionary: dictionary)
				
				self.posts.append(post)
			})
			self.collectionView.reloadData()
		}) { (err) in
			print("failed to fetch posts:", err)
		}
	}
}
