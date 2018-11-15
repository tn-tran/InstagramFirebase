//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/15/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	let plusPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
		return button
	}()
	
	@objc func handlePlusPhoto() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}
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
	

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let editedImage = info[.editedImage] as? UIImage {
			plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
		} else if let originalImage = info[.originalImage] as? UIImage {
			plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
		}
		
		
		plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
		plusPhotoButton.layer.masksToBounds = true
		plusPhotoButton.layer.borderColor = UIColor.black.cgColor
		plusPhotoButton.layer.borderWidth = 3
		dismiss(animated: true, completion: nil)
	}
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
		textField.text = "dummy"
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
			

//			print("Successfully created user:", result?.uid)
			guard let image = self.plusPhotoButton.imageView?.image else { return }
			guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return}
			let imageUrl = NSUUID().uuidString
			let storageRef = Storage.storage().reference().child("profile_images").child(imageUrl)
			
			storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
				storageRef.downloadURL(completion: { (url, err) in
					if let err = err {
						print("Failed to download URL:",err)
					}
					guard let profileImageUrl = url?.absoluteString else { return }
					
					guard let user = result?.user else { return }
					guard let fcmToken = Messaging.messaging().fcmToken else {  return }
					let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl, "fcmToken:": fcmToken]
					let values = [user.uid:dictionaryValues]
					Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
						if let err = err {
							print("Failed to save user info into db:", err)
							return
						}
						print("Successfully saved user info to db")
						guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
						mainTabBarController.setupViewControllers()
						self.dismiss(animated: true, completion: nil)
					})
				})
			})
		}
	}
	
	let alreadyHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
		attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
		button.setAttributedTitle(attributedTitle, for: .normal)
		
		button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
		return button
	}()
	
	@objc func handleAlreadyHaveAccount() {
		_ = navigationController?.popViewController(animated: true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = .white
		view.addSubview(alreadyHaveAccountButton)
		view.addSubview(plusPhotoButton)
		plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
		plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		
		alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
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

