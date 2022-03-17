//
//  CardView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class CardView: UIView {
	
	fileprivate let imageView = UIImageView(image: UIImage(named: "ladies"))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		addGestureRecognizer(panGesture)
		
		configureCardView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
			handleEnded()
		@unknown default:
			()
		}
	}
	
	fileprivate func handleEnded() {
		UIView.animate(withDuration: 0.7,
									 delay: 0,
									 usingSpringWithDamping: 0.6,
									 initialSpringVelocity: 0.1,
									 options: .curveEaseOut,
									 animations: {
			self.transform = .identity
		}, completion: nil)
	}
	
	fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: nil)
		self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
	}
}
