//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/23/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	var post: Post?
	let cellId = "cellId"
	lazy var containerView: UIView = {
		let containerView = UIView()
		containerView.backgroundColor = .white
		containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
		let submitButton = UIButton(type: .system)
		submitButton.setTitle("Submit", for: .normal)
		submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		submitButton.setTitleColor(.black, for: .normal)
		submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		containerView.addSubview(submitButton)
		submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
		
		
		containerView.addSubview(commentTextField)
		commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
		
		let lineSeparatorView = UIView()
		lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		containerView.addSubview(lineSeparatorView)
		lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
		return containerView
	}()
	
	let commentTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Comment"
		return textField
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		navigationItem.title = "Comments"
		
		collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
		collectionView?.alwaysBounceVertical = true
		collectionView?.keyboardDismissMode = .interactive
		
		collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
		collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
		
		fetchComments()
		
	}
	var comments = [Comment]()
	fileprivate func fetchComments() {
		guard let postId = self.post?.id else { return }
		let ref = Database.database().reference().child("comments").child(postId)
		ref.observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String:Any] else { return }
			guard let uid = dictionary["uid"] as? String else { return }
			Database.fetchUserWithUID(uid: uid, completion: { (user) in
				let comment = Comment(user: user, dictionary: dictionary)
				self.comments.append(comment)
				self.collectionView.reloadData()
			})

//			print(comment.text, comment.uid)
		}) { (err) in
			print("Failed to observe comments")
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarController?.tabBar.isHidden = true
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}
	
	override var inputAccessoryView: UIView? {
		get {
			return containerView
		}
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	@objc fileprivate func handleSubmit() {
		print("post id", self.post?.id ?? "")
		print("Handling submit...", commentTextField.text ?? "" )
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let postId = self.post?.id ?? ""
		let values = ["text": commentTextField.text ?? "",
					  "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
		Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
			if let err = err {
				print("Failed to insert comment", err)
				return
			}
			print("Successfully inserted comment.")
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comments.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
		cell.comment = self.comments[indexPath.item]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		let dummyCell = CommentsCell(frame: frame)
		dummyCell.comment = comments[indexPath.item]
		dummyCell.layoutIfNeeded()
		let targetSize = CGSize(width: view.frame.width, height: 1000)
		let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
		let height = max(40 + 8 + 8, estimatedSize.height)
		return CGSize(width: view.frame.width, height: height)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}