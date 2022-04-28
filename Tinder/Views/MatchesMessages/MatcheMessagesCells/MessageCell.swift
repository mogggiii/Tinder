//
//  MessageCell.swift
//  Tinder
//
//  Created by mogggiii on 25.04.2022.
//

import UIKit
import LBTATools


class MessageCell: LBTAListCell<Message> {
	
	var ancoredConstraint: AnchoredConstraints!
	
	let textView: UITextView = {
		let tv = UITextView()
		tv.backgroundColor = .clear
		tv.font = .systemFont(ofSize: 20)
		tv.isScrollEnabled = false
		tv.isEditable = false
		return tv
	}()
	
	let bubbleContainerView = UIView(backgroundColor: UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1))
	
	override var item: Message! {
		didSet {
			textView.text = item.text

			if item.isFromCurrentLoggedUser {
				/// right message bubble
				ancoredConstraint.leading?.isActive = false
				ancoredConstraint.trailing?.isActive = true
				bubbleContainerView.backgroundColor = UIColor(red: 22 / 255, green: 193 / 255, blue: 255 / 255, alpha: 1)
				textView.textColor = .white
			} else {
				/// left message bubble
				ancoredConstraint.leading?.isActive = true
				ancoredConstraint.trailing?.isActive = false
				bubbleContainerView.backgroundColor = UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1)
				textView.textColor = .black
			}
		}
	}
	
	override func setupViews() {
		super.setupViews()
		
		bubbleContainerView.layer.cornerRadius = 12
		
		addSubview(bubbleContainerView)
		ancoredConstraint = bubbleContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
		ancoredConstraint.leading?.constant = 20
		ancoredConstraint.trailing?.constant = -20
		
		bubbleContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true
		
		bubbleContainerView.addSubview(textView)
		textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
	}
}
