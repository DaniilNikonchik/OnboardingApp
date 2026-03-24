//
//  LocalizedKey.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 24.03.26.
//

import Foundation

enum L10n {

    // MARK: - Main

    enum Main {
        static let appTitle = NSLocalizedString("main.appTitle", comment: "")
        static let showOnboarding = NSLocalizedString("main.showOnboarding", comment: "")
        static let welcomeBack = NSLocalizedString("main.welcomeBack", comment: "")
        static let welcomeSubtitle = NSLocalizedString("main.welcomeSubtitle", comment: "")
        static let welcomeBackSubtitle = NSLocalizedString("main.welcomeBackSubtitle", comment: "")
        static let onboardingCompleted = NSLocalizedString("main.onboardingCompleted", comment: "")
        static let resetOnboarding = NSLocalizedString("main.resetOnboarding", comment: "")
        static let darkTheme = NSLocalizedString("main.darkTheme", comment: "")
        static let lightTheme = NSLocalizedString("main.lightTheme", comment: "")
    }

    // MARK: - Onboarding

    enum Onboarding {
        static let next = NSLocalizedString("onboarding.next", comment: "")
        static let start = NSLocalizedString("onboarding.start", comment: "")
    }

    // MARK: - Pages

    enum Pages {
        static let welcomeTitle = NSLocalizedString("pages.welcome.title", comment: "")
        static let welcomeDescription = NSLocalizedString("pages.welcome.description", comment: "")
        static let notificationsTitle = NSLocalizedString("pages.notifications.title", comment: "")
        static let notificationsDescription = NSLocalizedString("pages.notifications.description", comment: "")
        static let securityTitle = NSLocalizedString("pages.security.title", comment: "")
        static let securityDescription = NSLocalizedString("pages.security.description", comment: "")
    }
}
