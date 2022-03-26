//
//  CardView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class CardView: UIView {
	
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
	fileprivate let threshold: CGFloat = 80
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		addGestureRecognizer(panGesture)
		
		configureCardView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate methods 
	fileprivate func configureCardView() {
		layer.cornerRadius = 10
		clipsToBounds = true
		
		addSubview(imageView)
		imageView.fillSuperview()
		imageView.contentMode = .scaleAspectFill
		
		addSubview(informationLabel)
		informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0))

	}
	
	@objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
		switch gesture.state {
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
