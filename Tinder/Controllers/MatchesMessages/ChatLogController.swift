//
//  ChatLogController.swift
//  Tinder
//
//  Created by mogggiii on 25.04.2022.
//

import UIKit
import LBTATools

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
	
	fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
	fileprivate let navBarHeight: CGFloat = 120
	fileprivate let match: Match
	
	init(match: Match) {
		self.match = match
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		items = [
			.init(text: "HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO", isFromCurrentLoggedUser: true),
			.init(text: "HELLO", isFromCurrentLoggedUser: false),
			.init(text: "HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO", isFromCurrentLoggedUser: true),
		]
		
		customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
		
		collectionViewConfigure()
		setupNavBar()
	}
	
	// MARK: - CollectionView
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 16, left: 0, bottom: 16, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let estimatedSiezCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
		estimatedSiezCell.item = self.items[indexPath.item]
		estimatedSiezCell.layoutIfNeeded()
		
		let estimatedSize = estimatedSiezCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
		
		return .init(width: view.frame.width, height: estimatedSize.height)
	}
	
	// MARK: - Fileprivate methods
	fileprivate func setupNavBar() {
		view.addSubview(customNavBar)
		
		customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
		
		let statusBarCover = UIView(backgroundColor: .white)
		view.addSubview(statusBarCover)
		
		statusBarCover.anchor(top: view.topAnchor,  leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
	}
	
	fileprivate func collectionViewConfigure() {
		collectionView.contentInset.top = navBarHeight
		collectionView.verticalScrollIndicatorInsets.top = navBarHeight
		collectionView.alwaysBounceVertical = true
		collectionView.backgroundColor = .white
	}
	
	// MARK: - Objc fileprivate methods
	@objc fileprivate func handleBack() {
		navigationController?.popViewController(animated: true)
	}
}
