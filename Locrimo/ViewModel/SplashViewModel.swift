//
//  SplashViewModel.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import Foundation

protocol SplashViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<SplashViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
}

final class SplashViewModelImpl: SplashViewModel{
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
        
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.stateClosure?(.success(.appStart))
        }
    }
}

// MARK: ViewModel to ViewController interactivity
extension SplashViewModelImpl {
    enum ViewInteractivity {
        case appStart
    }
}
