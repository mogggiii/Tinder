//
//  LoginViewController.swift
//  Tinder
//
//  Created by mogggiii on 11.04.2022.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate: class {
	func didFinishLoggingIn()
}

class LoginViewController: UIViewController {
	
	fileprivate let gradientLayer = CAGradientLayer()
	fileprivate let hud = JGProgressHUD(style: .dark)
	
	let loginViewModel = LoginViewModel()
	weak var delegate: LoginControllerDelegate?
	
	// MARK: - UI Componets
	
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
	
	let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
		button.backgroundColor = .lightGray
		button.setTitleColor(.darkGray, for: .disabled)
		button.setTitleColor(.white, for: .normal)
		button.isEnabled = false
		button.heightAnchor.constraint(equalToConstant: 40).isActive = true
		button.layer.cornerRadius = 20
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()
	
	let goBackButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Back to Register", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16)
		button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
		return button
	}()
	
	lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
		stackView.axis = .vertical
		stackView.spacing = 8
		return stackView
	}()
	
	// MARK: - ViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTapGesture()
		setupLoginViewModel()
		setupGradientLayer()
		setupUI()
	}
	
	// MARK: - Fileprivate Methods
	
	fileprivate func setupLoginViewModel() {
		loginViewModel.isFormValid.bind { [weak self] isFormValid in
			guard let isFormValid = isFormValid else { return }
			self?.loginButton.isEnabled = isFormValid
			if isFormValid {
				self?.loginButton.backgroundColor = UIColor.rgb(red: 196, green: 24, blue: 79)
			} else {
				self?.loginButton.backgroundColor = .lightGray
			}
		}
		
		loginViewModel.isLoggingIn.bind { [weak self] isRegisterin in
			if isRegisterin == true {
				self?.hud.textLabel.text = "Login"
				self?.hud.show(in: self!.view)
			} else {
				self?.hud.dismiss()
			}
		}
	}
	
	fileprivate func setupUI() {
		navigationController?.isNavigationBarHidden = true
		view.addSubview(verticalStackView)
		verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
		verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		view.addSubview(goBackButton)
		goBackButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
	}
	
	fileprivate func setupGradientLayer() {
		let topColor = UIColor.rgb(red: 251, green: 94, blue: 95, alpha: 1)
		let bottomColor = UIColor.rgb(red: 227, green: 27, blue: 116, alpha: 1)
		gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
		gradientLayer.locations = [0, 1]
		gradientLayer.frame = view.bounds
		
		view.layer.addSublayer(gradientLayer)
	}
	
	fileprivate func setupTapGesture() {
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
	}
	
	// MARK: - Objc Fileprivate Methods
	
	@objc fileprivate func handleLogin() {
		loginViewModel.performLogin { [weak self] error in
			self?.hud.dismiss()
			if let error = error {
				print("Failed to login", error.localizedDescription)
				return
			}
			
			self?.dismiss(animated: true, completion: {
				self?.delegate?.didFinishLoggingIn()
			})
		}
	}
	
	@objc fileprivate func handleTextChange(textField: UITextField) {
		switch textField {
		case emailTextField:
			loginViewModel.email = textField.text
		case passwordTextField:
			loginViewModel.password = textField.text
		default:
			break
		}
	}
	
	@objc fileprivate func handleBack() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc fileprivate func handleTapDismiss() {
		self.view.endEditing(true)
	}
}
