//
//  ViewController.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeViewController: UIViewController {
	
	fileprivate var user: User?
	
	// MARK: UI Components
	lazy var topStackView = TopNavigationStackView()
	lazy var bottomControls = HomeBottomsStackView()
	lazy var cardDeckView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 10
		return view
	}()
	
	// MARK: - ViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		topStackView.settingsButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
		bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
		
		configureUI()
		fetchCurrentUser()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if Auth.auth().currentUser == nil {
			let loginController = LoginViewController()
			loginController.delegate = self
			let registerVC = RegistrationViewController()
			registerVC.delegate = self
			let navController = UINavigationController(rootViewController: loginController)
			navController.modalPresentationStyle = .fullScreen
			present(navController, animated: true)
		}
	}
	// MARK: - Fileprivate methods objc
	@objc fileprivate func handleSetting() {
		let settingsController = SettingsViewController()
		settingsController.delegate = self
		let navController = UINavigationController(rootViewController: settingsController)
		navController.modalPresentationStyle = .fullScreen
		present(navController, animated: true)
	}
	
	@objc fileprivate func handleRefresh() {
		fetchCurrentUser()
	}
	
	// MARK: - Fileprivate methods
	fileprivate func configureUI() {
		let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControls])
		overallStackView.axis = .vertical
		overallStackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(overallStackView)
		
		NSLayoutConstraint.activate([
			overallStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			overallStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			overallStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			overallStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
		])
		
		overallStackView.isLayoutMarginsRelativeArrangement = true
		overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
		overallStackView.bringSubviewToFront(cardDeckView)
	}
	
	fileprivate func fetchUsersFromFirestore() {
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Fetching Users..."
		hud.show(in: view)
		
		let minAge = user?.minSeekingAge ?? SettingsViewController.defaultMinSeekingAge
		let maxAge = user?.maxSeekingAge ?? SettingsViewController.defaultMaxSeekingAge
		
		let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
		query.getDocuments { snapshot, error in
			hud.dismiss()
			if let error = error {
				print("Error fetch users", error.localizedDescription)
				return
			}
			
			snapshot?.documents.forEach({ documentSnapshot in
				let userDictionary = documentSnapshot.data()
				let user = User(dictionary: userDictionary)
				if user.uid != Auth.auth().currentUser?.uid {
					self.setupCardFromUser(user: user)
				}
			})
		}
	}
	
	fileprivate func setupCardFromUser(user: User) {
		let cardView = CardView(frame: .zero)
		cardView.delegate = self
		cardView.cardViewModel = user.toCardViewModel()
		cardDeckView.addSubview(cardView)
		cardDeckView.sendSubviewToBack(cardView)
		cardView.fillSuperview()
	}
	
	fileprivate func fetchCurrentUser() {
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Loading"
		hud.show(in: view)
		cardDeckView.subviews.forEach { $0.removeFromSuperview() }
		Firestore.firestore().fetchCurrentUser { user, error in
			hud.dismiss()
			if let error = error {
				print("Error Fetch current user", error.localizedDescription)
				return
			}
			
			self.user = user
			self.fetchUsersFromFirestore()
		}
	}
}

// MARK: - SettingComtrollerDelegate
extension HomeViewController: SettingsControllerDelegate {
	func didSaveSettings() {
		fetchCurrentUser()
	}
}

// MARK: - LoginControllerDelegate
extension HomeViewController: LoginControllerDelegate {
	func didFinishLoggingIn() {
		fetchCurrentUser()
	}
}

// MARK: - RegistrationControllerDelegate
extension HomeViewController: RegistrationControllerDelegate {
	func didFinishRegister() {
		fetchCurrentUser()
	}
}

// MARK: - CardViewDelegate
extension HomeViewController: CardViewDelegate {
	func didTapMoreInfo(_ cardViewModel: CardViewModel) {
		let infoController = UserDetailsController()
		infoController.cardViewModel = cardViewModel
		infoController.modalPresentationStyle = .fullScreen
		present(infoController, animated: true)
	}
}

