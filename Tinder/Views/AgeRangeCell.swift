//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by mogggiii on 10.04.2022.
//

import UIKit

class AgeRangeLabel: UILabel {
	override var intrinsicContentSize: CGSize {
		return .init(width: 80, height: 0)
	}
}

class AgeRangeCell: UITableViewCell {
	
	let minSlider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 18
		slider.maximumValue = 100
		slider.isUserInteractionEnabled = true
		return slider
	}()
	
	let maxSlider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 18
		slider.maximumValue = 100
		slider.isUserInteractionEnabled = true
		return slider
	}()
	
	let minLabel: UILabel = {
		let label = AgeRangeLabel()
		label.font = .systemFont(ofSize: 15, weight: .bold)
		return label
	}()
	
	let maxLabel: UILabel = {
		let label = AgeRangeLabel()
		label.font = .systemFont(ofSize: 15, weight: .bold)
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupSliders()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupSliders() {
		let overalStackView = UIStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [minLabel, minSlider]),
			UIStackView(arrangedSubviews: [maxLabel, maxSlider]),
		])
		
		overalStackView.isUserInteractionEnabled = true
		overalStackView.axis = .vertical
		overalStackView.spacing = 16
		
		contentView.addSubview(overalStackView)
		let padding: CGFloat = 16
		overalStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
	}
}
