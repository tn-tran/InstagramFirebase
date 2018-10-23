//
//  CommentsCell.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/23/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit

class CommentsCell: UICollectionViewCell {
	var comment: Comment? {
		didSet {
			guard let comment = comment else { return }
//			guard let profileImageUrl = comment.user?.profileImageUrl else { return }
//			guard let username = comment.user?.username else { return }
			let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
			attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
			textView.attributedText = attributedText
			profileImageView.loadImage(urlString: comment.user.profileImageUrl)
		}
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(textView)
		addSubview(profileImageView)
		textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
		profileImageView.layer.cornerRadius = 40/2
		profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
		
	}
	let textView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 14)
//		label.numberOfLines = 0
		textView.isScrollEnabled = false
		
		return textView
	}()
	
	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.clipsToBounds = true
		iv.contentMode = .scaleAspectFill
		iv.backgroundColor = .blue
		
		return iv
	}()
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
