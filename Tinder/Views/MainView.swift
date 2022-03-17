//
//  MainView.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit

class MainView: UIView {
	
	// MARK: - UIElements
	
	// top and bottom stackViews
	lazy var topStackView = TopNavigationStackView()
	lazy var bottomStackView = HomeBottomsStackView()
	
	lazy var yellowView: UIView = {
		let view = UIView()
		view.backgroundColor = .yellow
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = .white
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate methods
	fileprivate func configureUI() {
		let overallStackView = UIStackView(arrangedSubviews: [topStackView, yellowView, bottomStackView])
		overallStackView.axis = .vertical
		overallStackView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(overallStackView)
		
		NSLayoutConstraint.activate([
			overallStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			overallStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			overallStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			overallStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),		
		])
	}
	
}
