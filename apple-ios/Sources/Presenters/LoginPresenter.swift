//
//  LoginPresenter.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

protocol LoginPresenterType {
    //プレゼンテーションアンカーとして使用するユーザーインターフェイス要素の種類を示すプラットフォーム固有のタイプ。
    func appleIDButtonDidTapped(anchor: ASPresentationAnchor)

}

final class LoginPresenter {

    // MARK: Dependency
    typealias Dependency = Dependencies
    struct Dependencies {
        let view: LoginView
        let model: LoginModelType
    }

    private weak var view: LoginView?
    private var model: LoginModelType?

}

extension LoginPresenter: LoginPresenterType {
    
    func appleIDButtonDidTapped(anchor: ASPresentationAnchor) {
        model?.login(ancher: anchor) { [weak self] (isSuccessful, error) in

        }
    }
}

extension LoginPresenter: PresenterInstantiable {

    func inject(with dependency: Dependencies) -> Self {
        self.view = dependency.view
        self.model = dependency.model
        return self
    }
}
