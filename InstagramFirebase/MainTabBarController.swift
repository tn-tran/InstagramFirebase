//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/16/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//
import Foundation
import UIKit
import Firebase
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let index = viewControllers?.index(of: viewController)
		if index == 2 { // the plus button
			let layout = UICollectionViewFlowLayout()
			let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
			let navController = UINavigationController(rootViewController: photoSelectorController)
			present(navController, animated: true, completion: nil)
			
			return false
		}
		return true
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		if Auth.auth().currentUser == nil {
			// show this controller if not logged in
			DispatchQueue.main.async {
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			}
			return
		}
		setupViewControllers()
	}
	
	func setupViewControllers() {
		//home
		let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
		
		// search
		let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
		
		let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
		
		let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
		//user profile
		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		let userProfileNavController = UINavigationController(rootViewController: userProfileController)
		userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
		userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
		tabBar.tintColor = .black
		viewControllers = [homeNavController,
						   searchNavController,
						   plusNavController,
						   likeNavController,
						   userProfileNavController]
		
		// modify tab bar insets
		guard let items = tabBar.items else { return }
		for item in items {
			item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
		}
	}
	
	fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
		let viewController = rootViewController
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.image = unselectedImage
		navController.tabBarItem.selectedImage = selectedImage
		return navController
	}
	
}
