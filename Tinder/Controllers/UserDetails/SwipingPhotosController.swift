//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by mogggiii on 13.04.2022.
//

import UIKit

class SwipingPhotosController: UIPageViewController {
	
	var controllers = [UIViewController]()
	
	// MARK: - CardViewModel
	var cardViewModel: CardViewModel? {
		didSet {
			guard let cardViewModel = cardViewModel else { return }
			
			controllers = cardViewModel.imageUrls.map({ imageUrl -> UIViewController in
				let photoController = PhotoController(imageUrl: imageUrl)
				return photoController
			})
			
			setViewControllers([controllers.first!], direction: .forward, animated: false)
			
			setupBarView()
		}
	}
	
	fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
	fileprivate let deselectBarColor = UIColor(white: 0, alpha: 0.1)
	
	// MARK: - VC Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		delegate = self
		dataSource = self
	}
	
	// MARK: Fileprivate Methods
	fileprivate func setupBarView() {
		cardViewModel?.imageUrls.forEach({ _ in
			let barView = UIView()
			barView.backgroundColor = deselectBarColor
			barView.layer.cornerRadius = 2
			barsStackView.addArrangedSubview(barView)
		})
		
		barsStackView.arrangedSubviews.first?.backgroundColor = .white
		barsStackView.spacing = 4
		barsStackView.distribution = .fillEqually
		view.addSubview(barsStackView)
		
		let topPadding = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 + CGFloat(8)
		barsStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: topPadding, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
	}
}

// MARK: - UIPageViewControllerDataSource
extension SwipingPhotosController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let index = self.controllers.firstIndex { $0 == viewController } ?? 0
		if index == 0 {
			return nil
		}
		return controllers[index - 1]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let index = self.controllers.firstIndex { $0 == viewController } ?? 0
		if index == controllers.count - 1 {
			return nil
		}
		return controllers[index + 1]
	}
}

// MARK: - UIPageViewControllerDelegate
extension SwipingPhotosController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let currentPhotoController = viewControllers?.first
		guard let index = controllers.firstIndex(where: { $0 == currentPhotoController }) else { return }
		barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectBarColor }
		barsStackView.arrangedSubviews[index].backgroundColor = .white
		
	}
}

// MARK: - PhotoController
class PhotoController: UIViewController {
	
	let imageView = UIImageView(image: UIImage(named: "jane1"))
	
	init(imageUrl: String) {
		if let url = URL(string: imageUrl) {
			imageView.sd_setImage(with: url)
		}
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(imageView)
		imageView.fillSuperview()
		imageView.contentMode = .scaleAspectFill
	}
}
