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
class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
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
		cell.delegate = self
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
				var post = Post(user: user, dictionary: dictionary)
				post.id = key
				guard let uid = Auth.auth().currentUser?.uid else { return }
				Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
					print(snapshot)
					if let value = snapshot.value as? Int, value == 1 {
						post.hasLiked = true
					} else {
						post.hasLiked = false
					}
					self.posts.append(post)
					self.posts.sort(by: { (post1, post2) -> Bool in
						return post1.creationDate.compare(post.creationDate) == .orderedDescending
					})
					self.collectionView.reloadData()
				}, withCancel: { (err) in
					print("Failed to fetch like info for post:", err)
				})
			})
		}) { (err) in
			print("failed to fetch posts:", err)
		}
	}
	func didTapComment(post: Post) {
		print("message coming HomeController")
		print(post.caption)
		let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
		commentsController.post = post
		navigationController?.pushViewController(commentsController, animated: true)
	}
	func didLike(for cell: HomePostCell) {
		print("Handling like inside of controller")
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		var post = self.posts[indexPath.item]
		guard let postId = post.id else { return }
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let value = [uid:post.hasLiked == true ? 0 : 1]
		Database.database().reference().child("likes").child(postId).updateChildValues(value) { (err, _) in
			if let err = err {
				print("failed to like post",err)
			}
//			print("Successfully liked post.")
			post.hasLiked = !post.hasLiked
			print(post.hasLiked == true ? "Successfully liked post." : "Successfully unliked post.")
			self.posts[indexPath.item] = post
			self.collectionView.reloadItems(at: [indexPath])
		}
	}
}
