//
//  UserDetailsController.swift
//  Tinder
//
//  Created by mogggiii on 12.04.2022.
//

import UIKit

class UserDetailsController: UIViewController {
	
	// MARK: - UIComponents
	lazy var scrollView: UIScrollView = {
		let sv = UIScrollView()
		sv.alwaysBounceVertical = true
		sv.contentInsetAdjustmentBehavior = .never
		sv.delegate = self
		return sv
	}()
	
	let imageView: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(named: "jane1")
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	
	let infoLabel: UILabel = {
		let label = UILabel()
		label.text = "Jane 38\n Doctor\n Some Bio"
		label.numberOfLines = 0
		label.textColor = .black
		label.font = .systemFont(ofSize: 18, weight: .bold)
		return label
	}()
	
	// MARK: - ViewController LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		view.backgroundColor = .white
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func setupUI() {
		view.addSubview(scrollView)
		scrollView.fillSuperview()
		
		scrollView.addSubview(imageView)
		scrollView.addSubview(infoLabel)
		imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
		
		let padding: CGFloat = 16
		infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
	}
	
	// MARK: - Objc Fileprivate methods
	@objc fileprivate func handleTapDismiss() {
		self.dismiss(animated: true)
	}
}

// MARK: - UIScrollViewDelegate
extension UserDetailsController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let changeY = -scrollView.contentOffset.y
		var width = view.frame.width + changeY * 2
		width = max(view.frame.width, width)
		imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
	}
}
