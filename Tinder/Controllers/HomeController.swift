//
//  ViewController.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
	
	var cardViewModel = [CardViewModel]()
	
	// MARK: UI Components
	
	lazy var topStackView = TopNavigationStackView()
	lazy var bottomStackView = HomeBottomsStackView()
	lazy var cardDeckView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 10
		return view
	}()
	
//	let cardViewModel: [CardViewModel] = {
//		let producers = [
//			User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
//			User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"]),
//			Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
//		] as [ProducesCardViewModel]
//
//		let viewModels = producers.map { return $0.toCardViewModel() }
//		return viewModels
//	}()
	
	// MARK: - ViewController Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		topStackView.settingsButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
		
		configureUI()
		setupDummyCards()
		fetchUsersFromFirestore()
	}
	
	// MARK: - Fileprivate methods
	
	@objc fileprivate func handleSetting() {
		print("Show registretion page")
		let registrationController = RegistrationViewController()
		registrationController.modalPresentationStyle = .fullScreen
		
		present(registrationController, animated: true)
	}
	
	fileprivate func configureUI() {
		let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomStackView])
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
	
	fileprivate func setupDummyCards() {
		cardViewModel.forEach { cardVM in
			let cardView = CardView(frame: .zero)
			cardView.cardViewModel = cardVM
			cardDeckView.addSubview(cardView)
			cardView.fillSuperview()
		}
	}
	
	fileprivate func fetchUsersFromFirestore() {
		Firestore.firestore().collection("users").getDocuments { snapshot, error in
			if let error = error {
				print("Error fetch users", error.localizedDescription)
				return
			}
			
			snapshot?.documents.forEach({ documentSnapshot in
				let userDictionary = documentSnapshot.data()
				let user = User(dictionary: userDictionary)
				self.cardViewModel.append(user.toCardViewModel())
				print(user.name, user.imageUrl1)
			})
			
			self.setupDummyCards()
		}
	}
	
}

