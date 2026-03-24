//
//  OnboardingViewModel.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import Foundation
import Combine

final class OnboardingViewModel {

    let pages: [OnboardingPage]
    let pageDidChange = PassthroughSubject<Int, Never>()
    private let userDefaultsService: UserDefaultsServiceProtocol

    private(set) var currentPageIndex = 0 {
        didSet { pageDidChange.send(currentPageIndex) }
    }

    var totalPages: Int { pages.count }
    var isLastPage: Bool { currentPageIndex == pages.count - 1 }

    var nextButtonTitle: String {
        isLastPage ? L10n.Onboarding.start : L10n.Onboarding.next
    }

    init(pages: [OnboardingPage], userDefaultsService: UserDefaultsServiceProtocol) {
        self.pages = pages
        self.userDefaultsService = userDefaultsService
    }

    func goToNextPage() {
        guard !isLastPage else { return }
        currentPageIndex += 1
    }

    func setPage(_ index: Int) {
        guard index >= 0, index < pages.count else { return }
        currentPageIndex = index
    }

    func completeOnboarding() {
        userDefaultsService.setOnboardingCompleted()
    }
}
