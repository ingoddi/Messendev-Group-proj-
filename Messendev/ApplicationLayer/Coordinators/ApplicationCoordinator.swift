//
//  ApplicationCoordinator.swift
//  Messendev
//
//  Created by Роман Анпилов on 03.02.2023.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private var userDefaultsService: UserDefaultService
    private var onboardingModuleFactory: OnboardingModuleFactory
    
    init(coordinatorFactory: CoordinatorFactory,
         router: Router,
         userDefaultsService: UserDefaultService,
         onboardingModuleFactory: OnboardingModuleFactory) {
        
        self.coordinatorFactory = coordinatorFactory
        self.router = router
        self.userDefaultsService = userDefaultsService
        self.onboardingModuleFactory = onboardingModuleFactory
    }
    
    override func start() {
        if !userDefaultsService.isNotFirstLaunch {
            runStartFlow()
            userDefaultsService.isNotFirstLaunch = true
        }

        if userDefaultsService.isLogin {
            runMainFlow()
        } else {
            runAuthFlow()
        }
        
    }
    
    private func runStartFlow() {
        let onboardingScreen = onboardingModuleFactory.makeOnboardingOutput()
        onboardingScreen.onLoginScreen = {[weak self] in
            self?.runAuthFlow()
        }
        router.push(onboardingScreen)
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(router: router)
//        coordinator.flowCompletionHandler
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        
    }
}
