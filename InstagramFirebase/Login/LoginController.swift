//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/17/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class LoginController: UIViewController {
	let logoContainerView: UIView = {
		let view = UIView()
		let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white") )
		view.addSubview(logoImageView)
		logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
		logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		logoImageView.contentMode = .scaleAspectFill
		view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
		return view
	}()
	let emailTextField: UITextField = {
		var textField = UITextField()
		textField.placeholder = "Email"
		textField.text = "dummy@gmail.com"
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let passwordTextField: UITextField = {
		var textField = UITextField()
		textField.placeholder = "Password"
		textField.text = "123456"
		textField.isSecureTextEntry = true
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 16)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login", for: .normal)
		button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		button.layer.cornerRadius = 5
		
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		button.isEnabled = false
		return button
	}()
	
	@objc func handleLogin() {
		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }
		Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
			if let err = err {
				print("Failed to sign in with email:", err)
				return
			}
			print("Successfuly logged in with user", user?.user.uid ?? "")
			guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
			mainTabBarController.setupViewControllers()
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	let dontHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
		attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
		button.setAttributedTitle(attributedTitle, for: .normal)
		
		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()
	
	
	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
		
		if isFormValid {
			loginButton.isEnabled = true
			loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
		} else {
			loginButton.isEnabled = false
			loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		}
		
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	@objc func handleShowSignUp() {
		let signUpController = SignUpController()
		
		navigationController?.pushViewController(signUpController, animated: true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationController?.isNavigationBarHidden = true
		view.addSubview(dontHaveAccountButton)
		view.addSubview(logoContainerView)
		
		logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
		dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		
		setupInputFields()
	}
	
	fileprivate func setupInputFields() {
		let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fillEqually
		
		view.addSubview(stackView)
		stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
	}
}
