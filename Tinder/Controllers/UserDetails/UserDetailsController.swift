//
//  UserDetailsController.swift
//  Tinder
//
//  Created by mogggiii on 12.04.2022.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController {
	
	var cardViewModel: CardViewModel! {
		didSet {
			infoLabel.attributedText = cardViewModel.attributedString
			
			guard let firstImageUrl = cardViewModel.imageUrls.first, let url = URL(string: firstImageUrl) else { return }
			imageView.sd_setImage(with: url)
		}
	}
	
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
	
	let dismissButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "dismissDown")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
		return button
	}()
	
	lazy var dislikeButton = createButton(imageName: "dismiss", selector: #selector(handleTapDismiss))
	lazy var superlikeButton = createButton(imageName: "favorite", selector: #selector(handleTapDismiss))
	lazy var likeButton = createButton(imageName: "like", selector: #selector(handleTapDismiss))
	
	// MARK: - ViewController LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		setupBlurView()
		setupButtonsControls()
		
		view.backgroundColor = .white
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func setupUI() {
		view.addSubview(scrollView)
		scrollView.fillSuperview()
		
		scrollView.addSubview(imageView)
		scrollView.addSubview(infoLabel)
		scrollView.addSubview(dismissButton)
		imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
		
		let padding: CGFloat = 16
		let dismissButtonSize: CGFloat = 44
		
		infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
		dismissButton.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: -dismissButtonSize / 2, left: 0, bottom: 0, right: padding), size: .init(width: dismissButtonSize, height: dismissButtonSize))
	}
	
	fileprivate func setupBlurView() {
		let visualEffect = UIBlurEffect(style: .regular)
		let visualEffectView = UIVisualEffectView(effect: visualEffect)
		
		view.addSubview(visualEffectView)
		visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
	}
	
	fileprivate func createButton(imageName: String, selector: Selector) -> UIButton {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: selector, for: .touchUpInside)
		button.imageView?.contentMode = .scaleAspectFill
		return button
	}
	
	fileprivate func setupButtonsControls() {
		let buttonsStackView = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
		buttonsStackView.axis = .horizontal
		buttonsStackView.spacing = -32
		buttonsStackView.distribution = .fillEqually
		
		view.addSubview(buttonsStackView)
		buttonsStackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
		buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
