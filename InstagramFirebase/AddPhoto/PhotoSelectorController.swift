//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/18/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import UIKit
import Photos
class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	let cellId = "cellId"
	let headerId = "headerId"
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		setupNavigationButtons()
		collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		
		fetchPhotos()
	}
	
	fileprivate func assetsFetchOptions() -> PHFetchOptions {
		let fetchOptions = PHFetchOptions()
		fetchOptions.fetchLimit =  30
		let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
		fetchOptions.sortDescriptors = [sortDescriptor]
		return fetchOptions
	}
	
	var images = [UIImage]()
	var assets = [PHAsset]()
	fileprivate func fetchPhotos() {
		let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
		DispatchQueue.global(qos: .background).async {
			allPhotos.enumerateObjects ({ (asset, count, stop) in
				let imageManager = PHImageManager.default()
				let targetSize = CGSize(width: 200, height: 200)
				let options = PHImageRequestOptions()
				options.isSynchronous = true
				imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options
					, resultHandler: { (image, info) in
						if let image = image {
							self.images.append(image)
							self.assets.append(asset)
							if self.selectedImage == nil {
								self.selectedImage = image
							}
						}
						if count == allPhotos.count - 1 {
							DispatchQueue.main.async {
								self.collectionView?.reloadData()
							}
						}
				})
			})
		}
	}
	var selectedImage: UIImage?
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.selectedImage = images[indexPath.item]
		self.collectionView?.reloadData()
		print(selectedImage)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let width = view.frame.width
		return CGSize(width: width, height: width)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
		header.photoImageView.image = selectedImage
		let imageManager = PHImageManager.default()
		if let selectedImage = selectedImage {
			if let index = self.images.index(of: selectedImage) {
				let selectedAsset = self.assets[index]
				let targetSize = CGSize(width: 600, height: 600)
				imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
					header.photoImageView.image = image
				}
			}
		}
		
		
		return header
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 3) / 4
		return CGSize(width: width, height: width)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return  1
	}
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
		cell.photoImageView.image = images[indexPath.item]
		return cell
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	fileprivate func setupNavigationButtons() {
		navigationController?.navigationBar.tintColor = .black
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
	}
	
	@objc func handleNext() {
		print("handling next")
	}
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
}
