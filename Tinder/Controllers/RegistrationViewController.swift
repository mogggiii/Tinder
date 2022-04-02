//
//  RegistrationViewController.swift
//  Tinder
//
//  Created by mogggiii on 02.04.2022.
//

import UIKit

class RegistrationViewController: UIViewController {
	
	// MARK: - UI Components
	
	let selectedPhoto: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Select Photo", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 32, weight: .heavy)
		button.backgroundColor = .white
		button.setTitleColor(.black, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 275).isActive = true
		button.layer.cornerRadius = 16
		return button
	}()
	
	let fullNameTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter full name"
		tf.backgroundColor = .white
		return tf
	}()
	
	let emailTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter email"
		tf.backgroundColor = .white
		tf.keyboardType = .emailAddress
		return tf
	}()
	
	let passwordTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter password"
		tf.backgroundColor = .white
		tf.isSecureTextEntry = true
		return tf
	}()
	
	let registerButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Register", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
		button.backgroundColor = UIColor.rgb(red: 196, green: 24, blue: 79)
		button.setTitleColor(.white, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 40).isActive = true
		button.layer.cornerRadius = 20
		return button
	}()
	
	
	
// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		setupGradientLayer()
		setupUI()
		setupNotificationObservers()
		setupTapGesture()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)
	}
	
// MARK: - Fileprivate Methods
	
	fileprivate func setupTapGesture() {
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
	}
	
	fileprivate func setupNotificationObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	fileprivate func setupGradientLayer() {
		let gradientLayer = CAGradientLayer()
		let topColor = UIColor.rgb(red: 251, green: 94, blue: 95, alpha: 1)
		let bottomColor = UIColor.rgb(red: 227, green: 27, blue: 116, alpha: 1)
		gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
		gradientLayer.locations = [0, 1]
		gradientLayer.frame = view.bounds
		
		view.layer.addSublayer(gradientLayer)
	}
	
	lazy var stackView = UIStackView(arrangedSubviews: [
		selectedPhoto,
		fullNameTextField,
		emailTextField,
		passwordTextField,
		registerButton
	])
	
	fileprivate func setupUI() {
		view.addSubview(stackView)
		stackView.axis = .vertical
		stackView.spacing = 8
		stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
	@objc fileprivate func handleKeyboardShow(notification: Notification) {
		guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardFrame = value.cgRectValue
		let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
		let difference = keyboardFrame.height - bottomSpace
		
		self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
	}
	
	@objc fileprivate func handleKeyboardHide() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
			self.view.transform = .identity
		}
	}
	
	@objc fileprivate func handleTapDismiss() {
		self.view.endEditing(true)
	}
}
