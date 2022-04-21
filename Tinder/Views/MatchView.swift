//
//  MatchView.swift
//  Tinder
//
//  Created by mogggiii on 19.04.2022.
//

import UIKit
import FirebaseFirestore

class MatchView: UIView {
	
	var currentUser: User? {
		didSet {
			
		}
	}
	
	var cardUID: String? {
		didSet {
			guard let cardUID = cardUID else { return }
			let reference = Firestore.firestore().collection("users")
			
			reference.document(cardUID).getDocument { snapshot, error in
				if let error = error {
					print("Failed to fetch card user", error)
					return
				}
				
				guard let dictionary = snapshot?.data() else { return }
				let user = User(dictionary: dictionary)
				guard let url = URL(string: user.imageUrl1 ?? "") else { return }
				
				guard let currentUser = self.currentUser, let currentUserImageUrl = URL(string: currentUser.imageUrl1 ?? "") else { return }
				self.currentUserImageView.sd_setImage(with: currentUserImageUrl)
				
				self.cardUserImageView.sd_setImage(with: url)
				self.setupAnimations()
				
				self.descriptionLabel.text = "You and \(user.name ?? "No Name") have liked\neach other"
			}
		}
	}
	
	
	// MARK: - UI Componets
	fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	
	fileprivate let itsAMatchImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "itsamatch"))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	fileprivate let descriptionLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = .systemFont(ofSize: 20)
		label.numberOfLines = 0
		return label
	}()
	
	fileprivate let currentUserImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 2
		imageView.layer.borderColor = UIColor.white.cgColor
		return imageView
	}()
	
	fileprivate let cardUserImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.alpha = 0
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 2
		imageView.layer.borderColor = UIColor.white.cgColor
		return imageView
	}()
	
	fileprivate let sendMessageButton: UIButton = {
		let button = SendMessageButton(type: .system)
		button.setTitle("SEND MESSAGE", for: .normal)
		button.setTitleColor(.white, for: .normal)
		return button
	}()
	
	fileprivate let keepSwipingButton: UIButton = {
		let button = KeepSwipingButton(type: .system)
		button.setTitle("Keep Swiping", for: .normal)
		button.setTitleColor(.white, for: .normal)
		return button
	}()
	
	lazy var views = [
		itsAMatchImageView,
		descriptionLabel,
		currentUserImageView,
		cardUserImageView,
		sendMessageButton,
		keepSwipingButton
	]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupBlurView()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func setupAnimations() {
		views.forEach { $0.alpha = 1 }
		
		let angle = 30 * CGFloat.pi / 180
		
		currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
		cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
		
		sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
		keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
		
		UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic) {
			
			/// animation 1 - translation to original position
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
				self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
				self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
			}
			
			/// animation 2 - rotation
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
				self.currentUserImageView.transform = .identity
				self.cardUserImageView.transform = .identity
			}
		} completion: { _ in
			
		}
		
		UIView.animate(withDuration: 0.6, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut) {
			self.sendMessageButton.transform = .identity
			self.keepSwipingButton.transform = .identity
		}
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
		views.forEach { view in
			addSubview(view)
			view.alpha = 0
		}
		
		let imageViewSize: CGFloat = 140
		let imageViewPadding: CGFloat = 16
		let buttonSize: CGFloat = 55
		
		itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
		itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		
		descriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
		
		currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: imageViewPadding), size: .init(width: imageViewSize, height: imageViewSize))
		currentUserImageView.layer.cornerRadius = imageViewSize / 2
		currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
		cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: imageViewPadding, bottom: 0, right: 0), size: .init(width: imageViewSize, height: imageViewSize))
		cardUserImageView.layer.cornerRadius = imageViewSize / 2
		cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
		sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: buttonSize))
		
		keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: buttonSize))
		keepSwipingButton.layer.cornerRadius = buttonSize / 2
	}
	
	// MARK: - Objc fileprivate methods
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
