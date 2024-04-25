//
//  AuthCoordinator.swift
//  Messendev
//
//  Created by Роман Анпилов on 03.02.2023.
//

import Foundation

final class OnboardingCoordinator: BaseCoordinator {

    private let router: Router
    private let authModuleFactory: AuthModuleFactory
    private var showLoginScreen:  (() -> Void)? 
    
    init(router: Router, authModuleFactory: AuthModuleFactory, showLoginScreen: (() -> Void)? ) {
        self.router = router
        self.authModuleFactory = authModuleFactory
        self.showLoginScreen = showLoginScreen
    }

    override func start() {
        showOnboardingScreen()
    }

    private func showOnboardingScreen() {
        let onboardingScreen = authModuleFactory.makeOnboardingOutput()
        onboardingScreen.onLoginScreen = {[weak self] in
            self?.showLoginScreen!()
        }
        router.push(onboardingScreen)
    }
}
