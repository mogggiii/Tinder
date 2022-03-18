//
//  CardView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class CardView: UIView {
	
	fileprivate let imageView = UIImageView(image: UIImage(named: "ladies"))
	
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
		
		UIView.animate(withDuration: 0.75,
									 delay: 0,
									 usingSpringWithDamping: 0.6,
									 initialSpringVelocity: 0.1,
									 options: .curveEaseOut,
									 animations: {
			if shouldDismissCard {
				let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
				self.transform = offScreenTransform
			} else {
				self.transform = .identity
			}
		}) { (_) in
			print("Completed animation")
			self.transform = .identity
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
