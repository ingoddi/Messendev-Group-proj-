//
//  OnboardinViewController.swift
//  Messendev
//
//  Created by Роман Анпилов on 03.02.2023.
//

import UIKit

protocol OnboardingView: BaseView {
    var onLoginScreen: (() -> Void)? { get set }
}

final class OnboardingViewController: UIPageViewController, OnboardingView {
        
    private var pages = [UIViewController]()
    private var pageControlBottomAnchor: NSLayoutConstraint?
    private var skipButtonBottomAnchor: NSLayoutConstraint?
    private let initialPage = 0
    
    var onLoginScreen: (() -> Void)?
    var model: OnboardingModel?
        
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .activeRed
        pageControl.pageIndicatorTintColor = .mainGray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        return pageControl
    }()
    
    private lazy var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(.systemPink, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        view.addSubview(skipButton)
        return skipButton
    }()
    
    init(model: OnboardingModel) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
        self.model = model
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.model?.initialize()
        }
    }
    
    override func updateViewConstraints() {
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
       
            skipButton.widthAnchor.constraint(equalToConstant: 50),
            skipButton.heightAnchor.constraint(equalToConstant: 20),
            skipButton.leadingAnchor.constraint(equalTo: pageControl.trailingAnchor, constant: -75),
            ])
        
            super.updateViewConstraints()
    
            pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor,
                                                                   multiplier: 2)
            pageControlBottomAnchor?.isActive = true
       
            skipButtonBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: skipButton.bottomAnchor,
                                                                  multiplier: 2)
            skipButtonBottomAnchor?.constant = 30
            skipButtonBottomAnchor?.isActive = true
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex != 0 {
            return pages[currentIndex - 1]
        }
        else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
            
        let nextIndex = currentIndex + 1
        
        if nextIndex >= pages.count {
            return nil
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]){
        if initialPage == pendingViewControllers.firstIndex(of: pages.last!) {
                onLoginScreen?()
        }
    }
}

extension OnboardingViewController {
    
    @objc
    private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    @objc
    private func skipButtonAction() {
        onLoginScreen?()
    }
}

extension OnboardingViewController: OnboardingModelOutput {
        
    func setPages(pages: [OnboardingPageCodable]) {
        DispatchQueue.main.async { [self] in
            pages.forEach { self.pages.append(OnboardingPageViewController(image: $0.image, titleText: $0.title, subtitleText: $0.subtitle))}
            self.pages.append(UIViewController())
            self.setViewControllers([self.pages[self.initialPage]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
            self.pageControl.numberOfPages = pages.count
        }
    }
}

