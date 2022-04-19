//
//  MatchView.swift
//  Tinder
//
//  Created by mogggiii on 19.04.2022.
//

import UIKit

class MatchView: UIView {
	
	fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	
	fileprivate let currentUserImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "jane1"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 2
		imageView.layer.borderColor = UIColor.white.cgColor
		return imageView
	}()
	
	fileprivate let cardUserImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "jane3"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 2
		imageView.layer.borderColor = UIColor.white.cgColor
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupBlurView()
		
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupBlurView() {
		visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
		
		addSubview(visualEffectView)
		visualEffectView.fillSuperview()
		visualEffectView.alpha = 0
		
		UIView.animate(withDuration: 0.5,
									 delay: 0,
									 usingSpringWithDamping: 1,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut) {
			self.visualEffectView.alpha = 1
		} completion: { _ in
			
		}

	}
	
	fileprivate func setupLayout() {
		addSubview(currentUserImageView)
		addSubview(cardUserImageView)
		
		let imageViewSize: CGFloat = 140
		let padding: CGFloat = 16
		
		currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: padding), size: .init(width: imageViewSize, height: imageViewSize))
		currentUserImageView.layer.cornerRadius = imageViewSize / 2
		currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
		cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: padding, bottom: 0, right: 0), size: .init(width: imageViewSize, height: imageViewSize))
		cardUserImageView.layer.cornerRadius = imageViewSize / 2
		cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
	}
	
	@objc fileprivate func handleTapDismiss() {
		UIView.animate(withDuration: 0.5,
									 delay: 0,
									 usingSpringWithDamping: 1,
									 initialSpringVelocity: 1,
									 options: .curveEaseOut) {
			self.alpha = 0
		} completion: { _ in
			self.removeFromSuperview()
		}
		
	}
}
