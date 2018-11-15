//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/15/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		window = UIWindow()
		window?.makeKeyAndVisible()
		
		window?.rootViewController = MainTabBarController()
		
		attempRegisterForNotifications(application: application)
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print("Registed for notifications", deviceToken)
	}
	
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		print("REgistering with FCM with token:", fcmToken)
	}
	
	
	fileprivate func attempRegisterForNotifications(application: UIApplication) {
		print("Attemping to register APNS...")
		
		Messaging.messaging().delegate = self
		
		// User notifcations auth
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
			if let err = err {
				print("Failed to request auth", err)
				return
			}
			if granted {
				print("Auth granted.")
			} else {
				print("Auth denied")
			}
		}
		application.registerForRemoteNotifications()
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

