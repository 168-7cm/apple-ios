//
//  LoginViewController.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import UIKit
import AuthenticationServices
import SnapKit
import FirebaseAuth

protocol LoginView: ViewBase {
    
}

final class LoginViewController: ViewControllerBase {

    typealias Dependency = Dependencies
    struct Dependencies {
        let preseter: LoginPresenterType
    }

    @IBOutlet private weak var signInWithAppleButtonContainerView: UIView!

    private var presenter: LoginPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppleIDButton()
    }

    @objc private func appleIDButtonDidTapped(_ sender: Any) {
        if let anchor = self.view.window { self.presenter?.appleIDButtonDidTapped(anchor: anchor) }
    }

    private func setupAppleIDButton() {
        // ユーザーがAppleでサインインフローを開始できるようにするインターフェイスに追加するコントロール。
        let appleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        appleIDButton.cornerRadius = 6.0
        signInWithAppleButtonContainerView.addSubview(appleIDButton)
        appleIDButton.snp.makeConstraints { $0.top.leading.trailing.bottom.equalToSuperview() }
        appleIDButton.addTarget(self, action: #selector(appleIDButtonDidTapped), for: .touchUpInside)
    }
}

extension LoginViewController: ViewControllerInstantiable {
    static func instansiate() -> LoginViewController {
        return R.storyboard.login.login()!
    }

    func inject(with dependency: Dependencies) {
        self.presenter = dependency.preseter
    }
}

extension LoginViewController: LoginView {
    
}
