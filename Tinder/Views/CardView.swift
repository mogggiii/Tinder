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
}

class CardView: UIView {
	
	weak var delegate: CardViewDelegate?
	
	// MARK: - CardViewModel
	
	var cardViewModel: CardViewModel! {
		didSet {
			let imageName = cardViewModel.imageUrls.first ?? ""
			/// load image using sdwebimage
			if let url = URL(string: imageName) {
				imageView.sd_setImage(with: url)
			}
			
			informationLabel.attributedText = cardViewModel.attributedString
			informationLabel.textAlignment = cardViewModel.textAlignment
			
			(0..<cardViewModel.imageUrls.count).forEach { _ in
				let barView = UIView()
				barView.layer.cornerRadius = 2
				barView.backgroundColor = barDeselectedColor
				barsStackView.addArrangedSubview(barView)
			}
			
			barsStackView.arrangedSubviews.first?.backgroundColor = .white
			
			setupImageIndexObserver()
		}
	}
	
	/// encapsulation
	fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
	fileprivate let barsStackView = UIStackView()
	fileprivate let threshold: CGFloat = 80
	fileprivate let gradientLayer = CAGradientLayer()
	fileprivate let imageView = UIImageView(image: UIImage(named: "ladies"))
	
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
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = self.frame
	}
	
	// MARK: - Fileprivate methods
	
	fileprivate func setupImageIndexObserver() {
		cardViewModel.imageIndexObserver = { [weak self] index, imageUrl in
			if let url = URL(string: imageUrl ?? "") {
				self?.imageView.sd_setImage(with: url)
			}
			
			self?.barsStackView.arrangedSubviews.forEach { view in
				view.backgroundColor = self?.barDeselectedColor
			}
			
			self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
		}
	}
	
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
		
		setupBarsStackView()
		
		/// Add a gradient layer
		setupGradientLayer()
		
		addSubview(informationLabel)
		informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
		
		addSubview(moreInfoButton)
		moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
	}
	
	fileprivate func setupBarsStackView() {
		addSubview(barsStackView)
		barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
		barsStackView.spacing = 4
		barsStackView.distribution = .fillEqually
	}
	
	// MARK: - Objc fileprivate
	
	@objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
		let tapLocation = gesture.location(in: nil)
		let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
		
		if shouldAdvanceNextPhoto {
			cardViewModel.advanceToNextPhoto()
		} else {
			cardViewModel.goToPreviousPhoto()
		}
	}
	
	@objc fileprivate func handleTapInfo() {
		self.delegate?.didTapMoreInfo(self.cardViewModel)
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
