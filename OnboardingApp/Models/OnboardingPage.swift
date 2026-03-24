//
//  OnboardingPage.swift
//  OnboardingApp
//
//  Created by Daniil Nikonchik on 18.03.26.
//

import UIKit

struct OnboardingPage {
    let imageName: String
    let sfSymbolName: String
    let title: String
    let description: String

    func resolveImage() -> UIImage? {
        if let asset = UIImage(named: imageName) {
            return asset
        }
        let config = UIImage.SymbolConfiguration(pointSize: 90, weight: .light)
        return UIImage(systemName: sfSymbolName, withConfiguration: config)
    }
}

extension OnboardingPage {
    static let defaultPages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding1",
            sfSymbolName: "hand.wave.fill",
            title: L10n.Pages.welcomeTitle,
            description: L10n.Pages.welcomeDescription
        ),
        OnboardingPage(
            imageName: "onboarding2",
            sfSymbolName: "bell.badge.fill",
            title: L10n.Pages.notificationsTitle,
            description: L10n.Pages.notificationsDescription
        ),
        OnboardingPage(
            imageName: "onboarding3",
            sfSymbolName: "checkmark.shield.fill",
            title: L10n.Pages.securityTitle,
            description: L10n.Pages.securityDescription
        )
    ]
}
