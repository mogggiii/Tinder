//
//  MessageCell.swift
//  Tinder
//
//  Created by mogggiii on 25.04.2022.
//

import UIKit
import LBTATools


class MessageCell: LBTAListCell<Message> {
	override var item: Message! {
		didSet {
			backgroundColor = .red
		}
	}
}
