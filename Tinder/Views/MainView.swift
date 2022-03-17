//
//  MainView.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit

class MainView: UIView {
	
	// MARK: - UIElements
	lazy var topStackView = TopNavigationStackView()
	lazy var bottomStackView = HomeBottomsStackView()
	
	lazy var cardDeckView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 10
		view.clipsToBounds = true 
		return view
	}()
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = .white
		configureUI()
		setupDummyCards()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate methods
	fileprivate func configureUI() {
		let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomStackView])
		overallStackView.axis = .vertical
		overallStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(overallStackView)
		
		NSLayoutConstraint.activate([
			overallStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			overallStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			overallStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			overallStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),		
		])
		
		overallStackView.isLayoutMarginsRelativeArrangement = true
		overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
		overallStackView.bringSubviewToFront(cardDeckView)
	}
	
	fileprivate func setupDummyCards() {
		let cardView = CardView(frame: .zero)
		cardDeckView.addSubview(cardView)

		cardView.fillSuperview()
	}
	
}
