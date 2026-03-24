//
//  OnboardingViewController.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import UIKit
import Combine

final class OnboardingViewController: UIViewController {

    private enum Layout {
        static let closeSize: CGFloat = 32
        static let buttonHeight: CGFloat = 54
        static let cornerRadius: CGFloat = 14
    }

    private let viewModel: OnboardingViewModel
    private var cancellables = Set<AnyCancellable>()
    var onDismiss: (() -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(OnboardingPageCell.self, forCellWithReuseIdentifier: OnboardingPageCell.reuseID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .systemGray4
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = Layout.cornerRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        btn.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        btn.tintColor = .secondaryLabel
        btn.backgroundColor = .systemGray5
        btn.layer.cornerRadius = Layout.closeSize / 2
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pageControl.numberOfPages = viewModel.totalPages

        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(pageControl)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: Layout.closeSize),
            closeButton.heightAnchor.constraint(equalToConstant: Layout.closeSize),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),

            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
        ])

        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        viewModel.pageDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.pageControl.currentPage = index
                self?.updateButton()
                self?.collectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
            .store(in: &cancellables)

        updateButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let size = collectionView.bounds.size
        guard layout.itemSize != size, size.width > 0, size.height > 0 else { return }
        layout.itemSize = size
        layout.invalidateLayout()
    }

    private func updateButton() {
        nextButton.setTitle(viewModel.nextButtonTitle, for: .normal)
        nextButton.backgroundColor = viewModel.isLastPage ? .systemGreen : .systemBlue
    }

    @objc private func nextTapped() {
        viewModel.isLastPage ? completeAndDismiss() : viewModel.goToNextPage()
    }

    @objc private func closeTapped() {
        completeAndDismiss()
    }

    private func completeAndDismiss() {
        viewModel.completeOnboarding()
        dismiss(animated: true) { self.onDismiss?() }
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.totalPages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingPageCell.reuseID, for: indexPath) as! OnboardingPageCell
        cell.configure(with: viewModel.pages[indexPath.item])
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            guard let pageCell = cell as? OnboardingPageCell else { continue }
            pageCell.applyParallax(offset: scrollView.contentOffset.x - cell.frame.origin.x)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        viewModel.setPage(Int(round(scrollView.contentOffset.x / width)))
    }
}
