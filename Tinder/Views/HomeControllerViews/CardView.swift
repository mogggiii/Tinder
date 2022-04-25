//
//  CardView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit
import SDWebImage

protocol CardViewDelegate: class {
	func didTapMoreInfo(_ cardViewModel: CardViewModel)
	func didRemoveCard(_ cardView: CardView)
	func didLike()
	func didDislike()
}

class CardView: UIView {
	
	var nextCardView: CardView?
	
	weak var delegate: CardViewDelegate?
	
	// MARK: - CardViewModel
	var cardViewModel: CardViewModel? {
		didSet {
			guard let cardViewModel = cardViewModel else { return }
			swipingPhotosController.cardViewModel = cardViewModel
			informationLabel.attributedText = cardViewModel.attributedString
			informationLabel.textAlignment = cardViewModel.textAlignment
		}
	}
	
	/// encapsulation
	fileprivate let threshold: CGFloat = 80
	fileprivate let gradientLayer = CAGradientLayer()
	fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
	
	// MARK: - UIComponents
	fileprivate lazy var informationLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = .white
		label.font = .systemFont(ofSize: 22, weight: .heavy)
		return label
	}()
	
	fileprivate let moreInfoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleTapInfo), for: .touchUpInside)
		return button
	}()
	
	// Configurations
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureCardView()
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		addGestureRecognizer(panGesture)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = self.frame
	}
	
	// MARK: - Fileprivate methods
	/// add gradient layer inside image view
	fileprivate func setupGradientLayer() {
		gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gradientLayer.locations = [0.5, 1.1]
		gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
		layer.addSublayer(gradientLayer)
	}
	
	/// configure the card view
	fileprivate func configureCardView() {
		layer.cornerRadius = 10
		clipsToBounds = true
		
		let swipingPhotosView = swipingPhotosController.view!
		addSubview(swipingPhotosView)
		swipingPhotosView.fillSuperview()
		
		/// Add a gradient layer
		setupGradientLayer()
		
		addSubview(informationLabel)
		informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
		
		addSubview(moreInfoButton)
		moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
	}
	
	// MARK: - Objc fileprivate
	@objc fileprivate func handleTapInfo() {
		guard let cardViewModel = cardViewModel else { return }
		self.delegate?.didTapMoreInfo(cardViewModel)
	}
	
	// MARK: - Animation
	@objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
		switch gesture.state {
		case .began:
			superview?.subviews.forEach({ subview in
				subview.layer.removeAllAnimations()
			})
		case .changed:
			handleChanged(gesture)
		case .ended:
			handleEnded(gesture: gesture)
		@unknown default:
			()
		}
	}
	
	fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
		let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
		let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
		
		if shouldDismissCard {
			if translationDirection == 1 {
				delegate?.didLike()
			} else {
				delegate?.didDislike()
			}
		} else {
			UIView.animate(withDuration: 1,
										 delay: 0,
										 usingSpringWithDamping: 0.6,
										 initialSpringVelocity: 0.1,
										 options: .curveEaseOut) {
				self.transform = .identity
			}
		}
	}
	
	fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: nil)
		// Rotation
		let degrees: CGFloat = translation.x / 20
		let angle = degrees * .pi / 180
		
		let rotationTransfor = CGAffineTransform(rotationAngle: angle)
		self.transform = rotationTransfor.translatedBy(x: translation.x, y: translation.y)
	}
	
}
