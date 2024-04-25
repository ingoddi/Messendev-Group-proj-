//
//  ViewController.swift
//  Messendev
//
//  Created by Роман Анпилов on 02.02.2023.
//

import UIKit

final class OnboardingPageViewController<View:OnboardingViewImpl>: BaseViewController<View> {
        
    private var image: String
    private var titleLabel: String
    private var subtitleLabel: String
    private weak var onboardingViewInput: OnboardingViewInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onboardingViewInput = rootView
        onboardingViewInput?.setDataOnboarding(image: image,
                                               title: titleLabel,
                                               subtitle: subtitleLabel)
    }
    
    init(image: String, titleText: String, subtitleText: String) {
        self.image = image
        self.titleLabel = titleText
        self.subtitleLabel = subtitleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

