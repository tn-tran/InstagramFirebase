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
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
		collectionView?.backgroundColor = .white
		collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		collectionView?.refreshControl = refreshControl
		setupNavigationItems()
		fetchAllPosts()
	}
	@objc func handleUpdateFeed() {
		handleRefresh()
	}
	@objc func handleRefresh() {
		print("Handling refresh...")
		posts.removeAll()
		fetchPost()
		fetchAllPosts()  // is this the fix?
	}
	fileprivate func fetchAllPosts() {
//		fetchPost() //this has a bug
		fetchFollowingUserIds()
	}
	fileprivate func fetchFollowingUserIds() {
		guard let uid = Auth.auth().currentUser?.uid else { return } // current id
		Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
			userIdsDictionary.forEach({ (key, value) in
				Database.fetchUserWithUID(uid: key, completion: { (user) in
					self.fetchPostsWithUser(user: user)
				})
			})
		}) { (err) in
			print("Failed to fetch following user ids:", err)
		}
	}
	
	fileprivate func setupNavigationItems() {
		navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysOriginal))
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
	}
	@objc func handleCamera() {
		print("showing camera")
		let cameraController = CameraController()
		present(cameraController, animated: true, completion: nil)
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
			self.collectionView?.refreshControl?.endRefreshing()
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			dictionary.forEach({ (key, value) in
				//				print("key \(key), Value: \(value)")
				guard let dictionary = value as? [String:Any] else { return }
				let post = Post(user: user, dictionary: dictionary)
				self.posts.sort(by: { (post1, post2) -> Bool in
					return post1.creationDate.compare(post.creationDate) == .orderedDescending
				})
				self.posts.append(post)
			})
			self.collectionView.reloadData()
		}) { (err) in
			print("failed to fetch posts:", err)
		}
	}
}
