//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/19/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
var imageCache = [String: UIImage]()
class CustomImageView: UIImageView {
	var lastUrlUsedToLoadImage: String?
	func loadImage(urlString: String) {
		if let cachedImage = imageCache[urlString] {
			self.image = cachedImage
			return
		}
		lastUrlUsedToLoadImage = urlString
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			if let err = err {
				print("failed to fetch post image:", err)
				return
			}
			
			if url.absoluteString != self.lastUrlUsedToLoadImage {
				return
			}
			guard let imageData = data else { return }
			let photoImage = UIImage(data: imageData)
			imageCache[url.absoluteString] = photoImage
			DispatchQueue.main.async {
				self.image = photoImage
			}
		}.resume()
	}
}
