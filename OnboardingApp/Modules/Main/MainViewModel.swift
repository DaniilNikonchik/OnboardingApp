//
//  MainViewModel.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import Foundation
import Combine

protocol MainViewModelProtocol: AnyObject {
    var buttonTitle: String { get }
    var showWelcomeBack: Bool { get }
    var stateDidChange: PassthroughSubject<Void, Never> { get }
    func checkOnboardingState()
    func makeOnboardingViewModel() -> OnboardingViewModel
    func resetOnboarding()
}

final class MainViewModel: MainViewModelProtocol {

    private let userDefaultsService: UserDefaultsServiceProtocol
    let stateDidChange = PassthroughSubject<Void, Never>()
    private(set) var showWelcomeBack = false

    var buttonTitle: String {
        showWelcomeBack ? L10n.Main.welcomeBack : L10n.Main.showOnboarding
    }

    init(userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
        checkOnboardingState()
    }

    func checkOnboardingState() {
        showWelcomeBack = userDefaultsService.hasCompletedOnboarding
        stateDidChange.send()
    }

    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel(
            pages: OnboardingPage.defaultPages,
            userDefaultsService: userDefaultsService
        )
    }

    func resetOnboarding() {
        userDefaultsService.resetOnboarding()
        checkOnboardingState()
    }
}
