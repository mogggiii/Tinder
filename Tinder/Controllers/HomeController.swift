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
	fileprivate var swipes = [String: Int]()
	
	var topCardView: CardView?
	
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
		
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .white
		
		topStackView.settingsButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
		topStackView.messagesButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
		bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
		bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
		bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
		
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
	// MARK: - Objc methods
	@objc fileprivate func handleSetting() {
		let settingsController = SettingsViewController()
		settingsController.delegate = self
		let navController = UINavigationController(rootViewController: settingsController)
		navController.modalPresentationStyle = .fullScreen
		present(navController, animated: true)
	}
	
	@objc fileprivate func handleRefresh() {
		cardDeckView.subviews.forEach({ $0.removeFromSuperview() })
		fetchUsersFromFirestore()
	}
	
	@objc fileprivate func handleLike() {
		saveSwipeToFirestore(didLike: 1)
		performSwipeAnimation(translation: 700, angle: 15)
	}
	
	@objc fileprivate func handleDislike() {
		saveSwipeToFirestore(didLike: 0)
		performSwipeAnimation(translation: -700, angle: -15)
	}
	
	@objc fileprivate func handleMessage() {
		let vc = MatchesMessagesController()
		navigationController?.pushViewController(vc, animated: true)
	}
	// MARK: - Fileprivate methods
	
	/// Saving swipes to firestore
	/// if didLike == 0, user press dislike button
	/// else user press like button
	fileprivate func saveSwipeToFirestore(didLike: Int) {
		guard let uid = Auth.auth().currentUser?.uid, let cardUID = topCardView?.cardViewModel?.uid else { return }
		
		let reference = Firestore.firestore().collection("swipes").document(uid)
		let documentData = [cardUID: didLike]
		
		reference.getDocument { [weak self] snapshot, error in
			if let error = error {
				print("Failed to fetch swipe documents", error.localizedDescription)
			}
			
			if snapshot?.exists == true {
				reference.updateData(documentData) { error in
					if let error = error {
						print("Failed to save", error.localizedDescription)
						return
					}
					
					if didLike == 1 {
						self?.chechIfMatchExist(cardUID: cardUID)
					}
				}
			} else {
				reference.setData(documentData) { error in
					if let error = error {
						print("Failed to save", error.localizedDescription)
						return
					}
					
					if didLike == 1 {
						self?.chechIfMatchExist(cardUID: cardUID)
					}
				}
			}
		}
	}
	
	fileprivate func chechIfMatchExist(cardUID: String) {
		Firestore.firestore().collection("swipes").document(cardUID).getDocument { snapshot, error in
			if let error = error {
				print("Failed to fetch document for card user", error)
				return
			}
			
			guard let data = snapshot?.data(), let uid = Auth.auth().currentUser?.uid else { return }
			print(data)
			let hasMatch = data[uid] as? Int == 1
			if hasMatch {
				self.presentMatchView(cardUID: cardUID)
			}
		}
	}
	
	fileprivate func presentMatchView(cardUID: String) {
		let matchView = MatchView()
		matchView.cardUID = cardUID
		matchView.currentUser = self.user
		view.addSubview(matchView)
		matchView.fillSuperview()
	}
	
	fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
		let duration = 0.4
		let translationAnimation = CABasicAnimation(keyPath: "position.x")
		translationAnimation.toValue = translation
		translationAnimation.duration = duration
		translationAnimation.fillMode = .forwards
		translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		translationAnimation.isRemovedOnCompletion = false
		
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.toValue = angle * CGFloat.pi / 180
		rotationAnimation.duration = duration
		
		let cardView = topCardView
		topCardView = cardView?.nextCardView
		
		CATransaction.setCompletionBlock {
			cardView?.removeFromSuperview()
		}
		
		cardView?.layer.add(translationAnimation, forKey: "translation")
		cardView?.layer.add(rotationAnimation, forKey: "rotation")
		
		CATransaction.commit()
	}
	
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
		topCardView = nil
		query.getDocuments { snapshot, error in
			hud.dismiss()
			if let error = error {
				print("Error fetch users", error.localizedDescription)
				return
			}
			
			// Linked list
			var previousCardView: CardView?
			
			snapshot?.documents.forEach({ documentSnapshot in
				let userDictionary = documentSnapshot.data()
				let user = User(dictionary: userDictionary)
				
				/// Setup all card views
				let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//				let hasNotSwipesBefore = self.swipes[user.uid!] == nil
				
				let hasNotSwipesBefore = true
				if isNotCurrentUser && hasNotSwipesBefore {
					let cardView = self.setupCardFromUser(user: user)
					
					previousCardView?.nextCardView = cardView
					previousCardView = cardView
					
					if self.topCardView == nil {
						self.topCardView = cardView
					}
				}
			})
		}
	}
	
	/// Setup card from user
	fileprivate func setupCardFromUser(user: User) -> CardView {
		let cardView = CardView(frame: .zero)
		cardView.delegate = self
		cardView.cardViewModel = user.toCardViewModel()
		cardDeckView.addSubview(cardView)
		cardDeckView.sendSubviewToBack(cardView)
		cardView.fillSuperview()
		return cardView
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
			self.fetchSwipes()
		}
	}
	
	fileprivate func fetchSwipes() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
			if let error = error {
				print("Failed to frych swipes", error)
				return
			}
			
			print(snapshot?.data() ?? "")
			guard let data = snapshot?.data() as? [String: Int] else { return }
			self.swipes = data
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
	
	func didRemoveCard(_ cardView: CardView) {
		self.topCardView?.removeFromSuperview()
		self.topCardView = self.topCardView?.nextCardView
	}
	
	func didLike() {
		handleLike()
	}
	
	func didDislike() {
		handleDislike()
	}
}

