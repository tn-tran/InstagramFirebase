//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
class HomePostCell: UICollectionViewCell {
	var post: Post? {
		didSet {
			guard let postImageUrl = post?.imageUrl else { return }
			photoImageView.loadImage(urlString: postImageUrl)
			usernameLabel.text = "TEST USERNAME"
			// wouldnt this be ncie
			usernameLabel.text = post?.user.username
			guard let profileImageUrl = post?.user.profileImageUrl else { return }
			userProfileViewImageView.loadImage(urlString: profileImageUrl)
//			captionLabel.text = post?.caption
			setupAttributedCaption()
		}
	}
	
	fileprivate func setupAttributedCaption() {
		guard let post = self.post else { return }
		let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
		attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
		let timeAgoDisplay = post.creationDate.timeAgoDisplay()
		attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
		self.captionLabel.attributedText = attributedText
	}
	let photoImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	let userProfileViewImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		
		return iv
	}()
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	let optionsButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("***", for: .normal)
		button.setTitleColor(.black, for: .normal)
		return button
	}()
	let likeButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let commentButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let sendMessageButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let bookmarkButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let captionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(photoImageView)
		addSubview(userProfileViewImageView)
		addSubview(usernameLabel)
		addSubview(optionsButton)
		userProfileViewImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
		userProfileViewImageView.layer.cornerRadius = 40 / 2
		photoImageView.anchor(top: userProfileViewImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		usernameLabel.anchor(top: self.topAnchor, left: userProfileViewImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		optionsButton.anchor(top: self.topAnchor, left: nil, bottom: photoImageView.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
		photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
		
		setupActionButtons()
		addSubview(bookmarkButton)
		bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		addSubview(captionLabel)
		captionLabel.anchor(top: likeButton.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		
	}
	fileprivate func setupActionButtons() {
		let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		addSubview(stackView)
		stackView.anchor(top: photoImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 120, height: 50)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
