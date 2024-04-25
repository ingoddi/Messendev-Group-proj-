//
//  OnboardingModel.swift
//  Messendev
//
//  Created by Роман Анпилов on 03.02.2023.
//

import Foundation

protocol OnboardingModelInput {
    func initialize() async
}

protocol OnboardingModelOutput: AnyObject {
    func setPages(pages: [OnboardingMainCodable])
}

final class OnboardingModel: OnboardingModelInput {
    
    private let onboardingService: OnboardingServiceable
    private weak var output: OnboardingModelOutput?
    
    init(onboardingService: OnboardingServiceable,
         output: OnboardingModelOutput) {
        self.onboardingService = onboardingService
        self.output = output
    }
    
    func initialize() async {
        do {
            let pages = try await onboardingService.getOnboardingPages()
        } catch let error {
            Log.error(error)
        }
    }
}
