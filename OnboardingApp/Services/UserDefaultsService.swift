//
//  UserDefaultsService.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    var hasCompletedOnboarding: Bool { get }
    func setOnboardingCompleted()
    func resetOnboarding()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {

    private enum Keys: String {
        case hasCompletedOnboarding
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding.rawValue)
    }

    func setOnboardingCompleted() {
        defaults.set(true, forKey: Keys.hasCompletedOnboarding.rawValue)
    }

    func resetOnboarding() {
        defaults.set(false, forKey: Keys.hasCompletedOnboarding.rawValue)
    }
}
