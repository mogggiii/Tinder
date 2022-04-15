//
//  RegistrationViewController.swift
//  Tinder
//
//  Created by mogggiii on 02.04.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD

protocol RegistrationControllerDelegate: class {
	func didFinishRegister()
}

class RegistrationViewController: UIViewController {
	
	fileprivate let gradientLayer = CAGradientLayer()
	
	weak var delegate: RegistrationControllerDelegate?
	let registrationViewModel = RegistrationViewModel()
	
	// MARK: - UI Components
	
	let registeringHUD = JGProgressHUD(style: .dark)
	
	let selectedPhoto: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Select Photo", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 32, weight: .heavy)
		button.backgroundColor = .white
		button.setTitleColor(.black, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 275).isActive = true
		button.layer.cornerRadius = 16
		button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
		button.imageView?.contentMode = .scaleAspectFill
		button.clipsToBounds = true
		return button
	}()
	
	let fullNameTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter full name"
		tf.backgroundColor = .white
		tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
		return tf
	}()
	
	let emailTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter email"
		tf.backgroundColor = .white
		tf.keyboardType = .emailAddress
		tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
		return tf
	}()
	
	let passwordTextField: CustomTextField = {
		let tf = CustomTextField(padding: 16)
		tf.placeholder = "Enter password"
		tf.backgroundColor = .white
		tf.isSecureTextEntry = true
		tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
		return tf
	}()
	
	let registerButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Register", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
		button.backgroundColor = .lightGray
		button.setTitleColor(.darkGray, for: .disabled)
		button.setTitleColor(.white, for: .normal)
		button.isEnabled = false
		button.heightAnchor.constraint(equalToConstant: 40).isActive = true
		button.layer.cornerRadius = 20
		button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
		return button
	}()
	
	let goToLoginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Go to Login", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16)
		button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupGradientLayer()
		setupUI()
		setupNotificationObservers()
		setupTapGesture()
		setupRegistrationViewModelObserver()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		gradientLayer.frame = view.bounds
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//		NotificationCenter.default.removeObserver(self)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if self.traitCollection.verticalSizeClass == .compact {
			overallStackView.axis = .horizontal
		} else {
			overallStackView.axis = .vertical
		}
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func showHUDWithError(error: Error) {
		registeringHUD.dismiss()
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Failed Registration"
		hud.detailTextLabel.text = error.localizedDescription
		hud.show(in: self.view)
		hud.dismiss(afterDelay: 4)
	}
	
	/// view model observer
	fileprivate func setupRegistrationViewModelObserver() {
		registrationViewModel.bindableIsFormValid.bind { [weak self] isFormValid in
			guard let isFormValid = isFormValid else { return }
			self?.registerButton.isEnabled = isFormValid
			if isFormValid {
				self?.registerButton.backgroundColor = UIColor.rgb(red: 196, green: 24, blue: 79)
			} else {
				self?.registerButton.backgroundColor = .lightGray
			}
		}
		
		registrationViewModel.bindableImage.bind { [weak self] image in
			self?.selectedPhoto.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
		}
		
		registrationViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
			if isRegistering == true {
				self?.registeringHUD.textLabel.text = "Register..."
				self?.registeringHUD.show(in: self!.view)
			} else {
				self?.registeringHUD.dismiss()
			}
		}
	}
	
	fileprivate func setupTapGesture() {
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
	}
	
	fileprivate func setupNotificationObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	fileprivate func setupGradientLayer() {
		let topColor = UIColor.rgb(red: 251, green: 94, blue: 95, alpha: 1)
		let bottomColor = UIColor.rgb(red: 227, green: 27, blue: 116, alpha: 1)
		gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
		gradientLayer.locations = [0, 1]
		gradientLayer.frame = view.bounds
		
		view.layer.addSublayer(gradientLayer)
	}
	
	lazy var verticalStackView: UIStackView = {
		let sv = UIStackView(arrangedSubviews: [
			fullNameTextField,
			emailTextField,
			passwordTextField,
			registerButton
		])
		
		sv.axis = .vertical
		sv.distribution = .fillEqually
		sv.spacing = 8
		return sv
	}()
	
	lazy var overallStackView = UIStackView(arrangedSubviews: [
		selectedPhoto,
		verticalStackView
	])
	
	fileprivate func setupUI() {
		navigationController?.isNavigationBarHidden = true
		view.addSubview(overallStackView)
		overallStackView.axis = .vertical
		selectedPhoto.widthAnchor.constraint(equalToConstant: 275).isActive = true
		overallStackView.spacing = 8
		overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
		overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		view.addSubview(goToLoginButton)
		goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
	}
	
	// MARK: - @Objc fileprivate
	
	@objc fileprivate func handleKeyboardShow(notification: Notification) {
		guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardFrame = value.cgRectValue
		let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
		let difference = keyboardFrame.height - bottomSpace
		
		self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
	}
	
	/// Hide keyboard with animation
	@objc fileprivate func handleKeyboardHide() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
			self.view.transform = .identity
		}
	}
	
	@objc fileprivate func handleTapDismiss() {
		self.view.endEditing(true)
	}
	
	@objc fileprivate func handleTextChange(textField: UITextField) {
		switch textField {
		case fullNameTextField:
			registrationViewModel.fullName = textField.text
		case emailTextField:
			registrationViewModel.email = textField.text
		case passwordTextField:
			registrationViewModel.password = textField.text
		default:
			break
		}
	}
	
	@objc fileprivate func handleRegister() {
		self.handleTapDismiss()
		registrationViewModel.performRegistration { [weak self] error in
			if let error = error {
				self?.showHUDWithError(error: error)
			}
			
			self?.dismiss(animated: true, completion: {
				self?.delegate?.didFinishRegister()
			})
			print("FINISH REGISTER USER")
		}
	}
	
	@objc fileprivate func handleSelectPhoto() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		present(imagePicker, animated: true)
	}
	
	@objc fileprivate func handleGoToLogin() {
		//		let loginContoller = LoginViewController()
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate 
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[.originalImage] as? UIImage
		registrationViewModel.bindableImage.value = image
		registrationViewModel.checkFormValidity()
		dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}
}
