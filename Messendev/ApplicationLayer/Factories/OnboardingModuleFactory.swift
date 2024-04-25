//
//  OnboardingModuleFactory.swift
//  Messendev
//
//  Created by дэвид Кихтенко on 21.02.2023.
//

import Foundation

protocol OnboardingModuleFactory {
    func makeOnboardingOutput() -> OnboardingView
}

final class OnboardingModuleFactoryImpl: OnboardingModuleFactory {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeOnboardingOutput() -> OnboardingView {
        let onboardingVC = OnboardingViewController()
        let service = container.resolve(type: OnboardingServiceable.self)
        let onbordingModel =  OnboardingModel(onboardingService: service,
                                              output: onboardingVC)
        onboardingVC.model = onbordingModel
        return onboardingVC
    }
    
}


