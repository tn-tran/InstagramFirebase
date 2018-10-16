//
//  UIColor+rbg.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/16/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
	static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
	
	
}
