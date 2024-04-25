//
//  ViewController.swift
//  Messendev
//
//  Created by Роман Анпилов on 02.02.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private var model: OnboardingModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SOSI"
        view.addSubview(label)
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = .init(x: 100, y: 100, width: 200, height: 200)
    }

}

