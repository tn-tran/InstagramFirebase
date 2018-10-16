//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/15/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
	
	let plusPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	
	let emailTextField: UITextField = {
		var textField = UITextField()
		textField.placeholder = "Email"
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	
	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
		
		if isFormValid {
			signupButton.isEnabled = true
			signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
		} else {
			signupButton.isEnabled = false
			signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		}
		
	}
	let usernameTextField: UITextField = {
		var textField = UITextField()
		textField.placeholder = "Username"
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let passwordTextField: UITextField = {
		var textField = UITextField()
		textField.placeholder = "Password"
		textField.isSecureTextEntry = true
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let signupButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign Up", for: .normal)
		button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		button.layer.cornerRadius = 5
		
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		
		button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
		button.isEnabled = false
		return button
	}()
	
	@objc func handleSignUp() {
		guard let email = emailTextField.text, email.count > 0 else { return }
		guard let username = usernameTextField.text, username.count > 0 else { return }
		guard let password = passwordTextField.text, password.count > 0 else { return }
		Auth.auth().createUser(withEmail: email, password: password) { (result, error: Error?) in
			if let err = error {
				print("Failed to create user:",err)
				return
			}
			
			guard let user = result?.user else { return }
			print("Successfully created user:", user.uid)
			
			let values = [user.uid:1]
			Database.database().reference().child("users").setValue(values, withCompletionBlock: { (err, ref) in
				if let err = err {
					print("Failed to save user info into db:", err)
					return
				}
				print("Successfully saved user info to db")
			})
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		view.addSubview(plusPhotoButton)
		plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
		plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		setupInputFields()
		
	}
	fileprivate func setupInputFields()  {
		let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
		stackView.distribution = .fillEqually
		stackView.axis = .vertical
		stackView.spacing = 10
		view.addSubview(stackView)
		
		//		stackView.anchor(top: plusPhotoButton.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
		stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
	}
	
}

extension UIView {
	func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
		}
		
		if let left = left {
			self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
		}
		
		
		if let bottom = bottom {
			self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
		}
		
		if let right = right {
			self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
		}
		
		if width != 0 {
			self.widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		
		
		if height != 0 {
			self.widthAnchor.constraint(equalToConstant: height).isActive = true
		}
		
	}
}
