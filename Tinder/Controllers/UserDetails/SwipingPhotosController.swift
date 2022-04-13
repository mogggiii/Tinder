//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by mogggiii on 13.04.2022.
//

import UIKit

class SwipingPhotosController: UIPageViewController {
	
	var controllers = [UIViewController]()
	
	var cardViewModel: CardViewModel? {
		didSet {
			guard let cardViewModel = cardViewModel else { return }
			
			controllers = cardViewModel.imageUrls.map({ imageUrl -> UIViewController in
				let photoController = PhotoController(imageUrl: imageUrl)
				return photoController
			})
			
			setViewControllers([controllers.first!], direction: .forward, animated: false)
		}
	}
	
	// MARK: - VC Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		dataSource = self
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
