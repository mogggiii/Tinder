//
//  ViewController.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit

class HomeController: UIViewController {
	
	// MARK: UIElements
	lazy var topStackView = TopNavigationStackView()
	lazy var bottomStackView = HomeBottomsStackView()
	lazy var cardDeckView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 10
		return view
	}()
	
	let users = [
		User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "ladies"),
		User(name: "Jane", age: 18, profession: "Teacher", imageName: "like"),
	]

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		configureUI()
		setupDummyCards()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .darkContent
	}
	
	// MARK: - Fileprivate methods
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
		users.forEach { user in
			let cardView = CardView(frame: .zero)
			cardView.user = user
			cardDeckView.addSubview(cardView)
			cardView.fillSuperview()
		}
	}

}

