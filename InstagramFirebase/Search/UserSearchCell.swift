//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/21/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit

class UserSearchCell: UICollectionViewCell {
	var user: User? {
		didSet {
			usernameLabel.text = user?.username
			guard let profileImageUrl = user?.profileImageUrl else { return }
			profileImageView.loadImage(urlString: profileImageUrl)
		}
	}
	
	let profileImageView: CustomImageView = {
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
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		
		addSubview(profileImageView)
		addSubview(usernameLabel)
		profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		profileImageView.layer.cornerRadius = 50/2
		profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		usernameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		let separatorView = UIView()
		separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		addSubview(separatorView)
		separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) was not loaded")
	}
}
