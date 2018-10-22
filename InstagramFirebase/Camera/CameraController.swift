//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/22/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class CameraController: UIViewController {
	let dismissButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleDimiss), for: .touchUpInside)
		return button
	}()
	let capturePhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
		return button
	}()
	
	@objc func handleDimiss() {
		dismiss(animated: true, completion: nil)
	}
	@objc func handleCapturePhoto() {
		print("Capturing photo...")
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCaptureSession()
		setupHUD()
	}
	fileprivate func setupHUD() {
		view.addSubview(capturePhotoButton)
		capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
		capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		view.addSubview(dismissButton)
		dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
	}
	fileprivate func setupCaptureSession() {
		let captureSession = AVCaptureSession()
		//1. setup inputs
		guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
			}
			
		} catch let err {
			print("Could not setup camera input", err)
		}
		
		// 2. setup outputs
		let output = AVCapturePhotoOutput()
		if captureSession.canAddOutput(output) {
			captureSession.addOutput(output)
		}
		// 3. setup output preview
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.frame
		view.layer.addSublayer(previewLayer)
		captureSession.startRunning()
	}
	
	
}
