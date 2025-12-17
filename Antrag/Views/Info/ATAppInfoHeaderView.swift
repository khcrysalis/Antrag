//
//  ATAppInfoHeaderView.swift
//  Antrag
//
//  Created by samara on 7.06.2025.
//

import UIKit
import IDeviceSwift

// MARK: - Class
class ATAppInfoHeaderView: UIView {
	let padding: CGFloat = 21
	var identifier: String = ""
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.numberOfLines = 1
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13,  weight: .regular)
		label.textColor = .secondaryLabel
		label.numberOfLines = 1
		return label
	}()
	
	let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerCurve = .continuous
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 1.0
		imageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
		return imageView
	}()
	
	let openButton: UIButton = ATOpenButton(type: .system)
	
	// MARK: Overrides
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		iconImageView.layer.cornerRadius = iconImageView.frame.height * 0.2337
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		iconImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
	}
	
	// MARK: Setup
	
	private func _setup() {
		let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
		labelsStackView.axis = .vertical
		labelsStackView.spacing = 4
		
		[iconImageView, labelsStackView, openButton].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		let halfPadding = padding / 2
		let slightlyOverHalfPadding = halfPadding * 1.3
		
		NSLayoutConstraint.activate([
			iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: halfPadding),
			iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding),
			iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
			
			labelsStackView.topAnchor.constraint(equalTo: topAnchor, constant: halfPadding),
			labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: slightlyOverHalfPadding),
			labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			
			openButton.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: slightlyOverHalfPadding),
			openButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -padding),
			openButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding)
		])
		
		openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
		
		iconImageView.isUserInteractionEnabled = true
		let interaction = UIContextMenuInteraction(delegate: self)
		iconImageView.addInteraction(interaction)
	}
	
	@objc private func openButtonTapped() {
		UIApplication.openApp(with: identifier)
	}
	
	func configure(with app: AppInfo) {
		let name = app.CFBundleDisplayName ?? app.CFBundleExecutable
		let identifier = app.CFBundleIdentifier ?? ""
		self.identifier = identifier
		
		nameLabel.text = name
		descriptionLabel.text = identifier
		
		Task { [weak self] in
			guard let self else { return }
			if let image = try? await InstallationAppProxy.getAppIconCached(for: identifier) {
				DispatchQueue.main.async {
					self.iconImageView.image = image
				}
			}
		}
	}
}

extension ATAppInfoHeaderView: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(
		_ interaction: UIContextMenuInteraction,
		configurationForMenuAtLocation location: CGPoint
	) -> UIContextMenuConfiguration? {
		
		guard let image = iconImageView.image else { return nil }
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: {
			let vc = UIViewController()
			
			let imageView = UIImageView(image: image)
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			
			vc.view.addSubview(imageView)
			vc.view.backgroundColor = .clear
			
			NSLayoutConstraint.activate([
				imageView.topAnchor.constraint(equalTo: vc.view.topAnchor),
				imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
				imageView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
				imageView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
			])
			
			return vc
		}) { _ in
			let saveAction = UIAction(
				title: .localized("Save Image"),
				image: UIImage(systemName: "square.and.arrow.down")
			) { _ in
				UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
			}
			
			return UIMenu(children: [saveAction])
		}
	}
}
