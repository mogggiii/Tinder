//
//  CardView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class CardView: UIView {
	
	/// encapsulation
	fileprivate let threshold: CGFloat = 80
	fileprivate let gradientLayer = CAGradientLayer()
	
	// MARK: - CardViewModel
	
	var cardViewModel: CardViewModel! {
		didSet {
			imageView.image = UIImage(named: cardViewModel.imageName)
			informationLabel.attributedText = cardViewModel.attributedString
			informationLabel.textAlignment = cardViewModel.textAlignment
		}
	}
	
	// MARK: - UIElements
	
  fileprivate let imageView = UIImageView(image: UIImage(named: "ladies"))
	fileprivate lazy var informationLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = .white
		label.font = .systemFont(ofSize: 22, weight: .heavy)
		return label
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
		
		addSubview(imageView)
		imageView.fillSuperview()
		imageView.contentMode = .scaleAspectFill
		
		/// Add a gradient layer
		setupGradientLayer()
		
		addSubview(informationLabel)
		informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
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
		
		UIView.animate(withDuration: 1,
									 delay: 0,
									 usingSpringWithDamping: 0.6,
									 initialSpringVelocity: 0.1,
									 options: .curveEaseOut,
									 animations: {
			if shouldDismissCard {
				let offScreenTransform = self.transform.translatedBy(x: 600 * translationDirection, y: 0)
				self.transform = offScreenTransform
			} else {
				self.transform = .identity
			}
		}) { (_) in
			self.transform = .identity
			if shouldDismissCard {
				self.removeFromSuperview()
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
