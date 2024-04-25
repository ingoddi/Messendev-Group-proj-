//
//  AuthModuleFactory.swift
//  Messendev
//
//  Created by Роман Анпилов on 03.02.2023.
//

import Foundation

protocol AuthModuleFactory {
    func makeLoginOutput() -> LoginView
    func makeFillDataUserOutput() -> FillUserDataView
    func makeOTPVerifyOutput() -> OTPVerifyView
}

final class AuthModuleFactoryImpl: AuthModuleFactory {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeLoginOutput() -> LoginView {
        let loginModule = LoginViewController<LoginViewImpl>()
        return loginModule
    }
    
    func makeFillDataUserOutput() -> FillUserDataView {
        return FillUserDataViewController<FillUserDataViewImpl>()
    }
    
    func makeOTPVerifyOutput() -> OTPVerifyView {
        return OTPVerifyViewController<OTPVerifyViewImpl>()
    }
}


