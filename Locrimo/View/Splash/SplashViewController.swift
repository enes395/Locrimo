//
//  SplashViewController.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit
// Any object anlamadım 
protocol SplashViewControllerDelegate: AnyObject {
    func appStart()
}

extension SplashViewControllerDelegate {
    func appStart() {}
}

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var viewModel: SplashViewModel!
    weak var delegate: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addObservationListener()
        viewModel.start()
    }
    
    private func setupView() {
        
        splashImage.image = UIImage(named: "splashImage.png")
        messageLabel.font = UIFont.avenir(.Heavy, size: 36)
        messageLabel.textColor = .rickGreen
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            messageLabel.text = "Hello!"
        } else {
            messageLabel.text = "Welcome!"
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }

    func inject(viewModel: SplashViewModel, delegate: SplashViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
}

// MARK: - ViewModel Listener
extension SplashViewController {
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: SplashViewModelImpl.ViewInteractivity) {
        switch data {
        case .appStart:
            delegate?.appStart()
        }
    }
}
