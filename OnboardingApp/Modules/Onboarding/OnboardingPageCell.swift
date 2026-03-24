//
//  OnboardingPageCell.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import UIKit

final class OnboardingPageCell: UICollectionViewCell {

    static let reuseID = "OnboardingPageCell"

    // MARK: - Constants

    private enum Layout {
        static let backgroundSize: CGFloat = 240
        static let backgroundCorner: CGFloat = 24
        static let imageSize: CGFloat = 180
        static let topInset: CGFloat = 80
        static let titleTopSpacing: CGFloat = 40
        static let descTopSpacing: CGFloat = 16
        static let horizontalInset: CGFloat = 32
        static let parallaxFactor: CGFloat = 0.35
    }

    // MARK: - UI

    private let imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Layout.backgroundCorner
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) var pageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func addSubviews() {
        contentView.addSubview(imageBackground)
        imageBackground.addSubview(pageImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.topInset),
            imageBackground.widthAnchor.constraint(equalToConstant: Layout.backgroundSize),
            imageBackground.heightAnchor.constraint(equalToConstant: Layout.backgroundSize),

            pageImageView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            pageImageView.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor),
            pageImageView.widthAnchor.constraint(equalToConstant: Layout.imageSize),
            pageImageView.heightAnchor.constraint(equalToConstant: Layout.imageSize),

            titleLabel.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: Layout.titleTopSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalInset),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.descTopSpacing),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalInset),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalInset),
        ])
    }

    // MARK: - Configure

    func configure(with page: OnboardingPage) {
        titleLabel.text = page.title
        descLabel.text = page.description
        pageImageView.image = page.resolveImage()
    }

    func applyParallax(offset: CGFloat) {
        pageImageView.transform = CGAffineTransform(
            translationX: offset * Layout.parallaxFactor,
            y: 0
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pageImageView.transform = .identity
        pageImageView.image = nil
    }
}
