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
	
	var cardViewModel = [CardViewModel]()
	var lastFetchUser: User?
	
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
		setupFirestoreUserCards()
		fetchUsersFromFirestore()
	}
	
// MARK: - Fileprivate methods objc
	@objc fileprivate func handleSetting() {
		let settingsController = SettingsViewController()
		let navController = UINavigationController(rootViewController: settingsController)
		navController.modalPresentationStyle = .fullScreen
		present(navController, animated: true)
	}
	
	@objc fileprivate func handleRefresh() {
		print("Refresh")
		fetchUsersFromFirestore()
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
	
	fileprivate func setupFirestoreUserCards() {
		cardViewModel.forEach { cardVM in
			let cardView = CardView(frame: .zero)
			cardView.cardViewModel = cardVM
			cardDeckView.addSubview(cardView)
			cardView.fillSuperview()
		}
	}
	
	fileprivate func fetchUsersFromFirestore() {
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Fetching Users..."
		hud.show(in: view)
		
		let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchUser?.uid ?? ""]).limit(to: 2)
		query.getDocuments { snapshot, error in
			hud.dismiss()
			if let error = error {
				print("Error fetch users", error.localizedDescription)
				return
			}
			
			snapshot?.documents.forEach({ documentSnapshot in
				let userDictionary = documentSnapshot.data()
				let user = User(dictionary: userDictionary)
				self.cardViewModel.append(user.toCardViewModel())
				self.lastFetchUser = user
				print(user.uid)
				self.setupCardFromUser(user: user)
			})
			
			self.cardViewModel.removeAll()
		}
	}
	
	fileprivate func setupCardFromUser(user: User) {
		cardViewModel.forEach { cardVM in
			let cardView = CardView(frame: .zero)
			cardView.cardViewModel = user.toCardViewModel()
			cardDeckView.addSubview(cardView)
			cardDeckView.sendSubviewToBack(cardView)
			cardView.fillSuperview()
		}
	}
	
}

