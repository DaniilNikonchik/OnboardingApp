//
//  MainViewController.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import UIKit
import Combine

final class MainViewController: UIViewController {

    private enum Layout {
        static let logoSize: CGFloat = 100
        static let logoCenterOffset: CGFloat = -160
        static let buttonHeight: CGFloat = 54
        static let horizontalInset: CGFloat = 40
        static let cornerRadius: CGFloat = 14
        static let badgeCornerRadius: CGFloat = 12
    }

    private let viewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badgeView = UIView()
    private let badgeLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let themeInfoLabel = UILabel()

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addSubviews()
        setupConstraints()
        setupActions()
        setupBindings()
        registerThemeChanges()
        updateUI()
    }

    func refreshState() {
        viewModel.checkOnboardingState()
    }

    // MARK: - Theme tracking (iOS 15–18)

    private func registerThemeChanges() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
                (vc: MainViewController, _: UITraitCollection) in
                vc.updateThemeLabel()
            }
        }
    }

    @available(iOS, deprecated: 17.0)
    override func traitCollectionDidChange(_ prev: UITraitCollection?) {
        super.traitCollectionDidChange(prev)
        if #unavailable(iOS 17.0) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: prev) {
                updateThemeLabel()
            }
        }
    }

    // MARK: - Configure

    private func configureViews() {
        view.backgroundColor = .systemBackground

        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
        logoImageView.image = UIImage(systemName: "app.fill", withConfiguration: config)
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = L10n.Main.appTitle
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        badgeView.backgroundColor = .systemGreen.withAlphaComponent(0.12)
        badgeView.layer.cornerRadius = Layout.badgeCornerRadius
        badgeView.isHidden = true
        badgeView.translatesAutoresizingMaskIntoConstraints = false

        badgeLabel.text = L10n.Main.onboardingCompleted
        badgeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        badgeLabel.textColor = .systemGreen
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = Layout.cornerRadius
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        resetButton.setTitle(L10n.Main.resetOnboarding, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 14)
        resetButton.setTitleColor(.secondaryLabel, for: .normal)
        resetButton.isHidden = true
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        themeInfoLabel.font = .systemFont(ofSize: 12, weight: .regular)
        themeInfoLabel.textColor = .tertiaryLabel
        themeInfoLabel.textAlignment = .center
        themeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        view.addSubview(actionButton)
        view.addSubview(resetButton)
        view.addSubview(themeInfoLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Layout.logoCenterOffset),
            logoImageView.widthAnchor.constraint(equalToConstant: Layout.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Layout.logoSize),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            badgeView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            badgeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 8),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -8),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -16),

            actionButton.topAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalInset),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalInset),
            actionButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),

            resetButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            themeInfoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            themeInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - Bindings

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateUI() }
            .store(in: &cancellables)
    }

    // MARK: - Updates

    private func updateUI() {
        let completed = viewModel.showWelcomeBack

        subtitleLabel.text = completed ? L10n.Main.welcomeBackSubtitle : L10n.Main.welcomeSubtitle
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)
        actionButton.backgroundColor = completed ? .systemGreen : .systemBlue
        badgeView.isHidden = !completed
        resetButton.isHidden = !completed

        updateThemeLabel()
    }

    private func updateThemeLabel() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        themeInfoLabel.text = isDark ? L10n.Main.darkTheme : L10n.Main.lightTheme
    }

    // MARK: - Actions

    @objc private func actionTapped() {
        let vm = viewModel.makeOnboardingViewModel()
        let vc = OnboardingViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        vc.onDismiss = { [weak self] in self?.refreshState() }
        present(vc, animated: true)
    }

    @objc private func resetTapped() {
        viewModel.resetOnboarding()
    }
}
