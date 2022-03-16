//
//  MainView.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit

class MainView: UIView {
	
	let subviewsd = [UIColor.gray, UIColor.darkGray, UIColor.black].map { color -> UIView in
		let v = UIView()
		v.backgroundColor = color
		return v
	}
	
	lazy var topStackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: subviewsd)
		view.distribution = .fillEqually
		return view
	}()
	
	lazy var redView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		return view
	}()
	
	lazy var yellowView: UIView = {
		let view = UIView()
		view.backgroundColor = .yellow
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var grayView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = .white
		
		setUp()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUp() {
		
		let stackView = UIStackView(arrangedSubviews: [topStackView, yellowView, redView])
		stackView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
		stackView.axis = .vertical
		self.addSubview(stackView)
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		// Use Autho Layout
		NSLayoutConstraint.activate([
			//StackView
			stackView.topAnchor.constraint(equalTo: self.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		
			topStackView.heightAnchor.constraint(equalToConstant: 100),
			
			redView.heightAnchor.constraint(equalToConstant: 120)
		])
	}
	
}
