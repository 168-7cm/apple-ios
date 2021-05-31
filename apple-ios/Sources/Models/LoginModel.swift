//
//  LoginModel.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import Foundation
import AuthenticationServices

typealias LoginResult = (_ isSuccessful: Bool, _ error: Error?) -> ()

protocol  LoginModelType {
    func login(ancher: ASPresentationAnchor, completion: @escaping LoginResult)
}

final class LoginModel: LoginModelType {

    func login(ancher: ASPresentationAnchor, completion: @escaping LoginResult) {
        FirebaseAppleAuthentification.shared.login(ancher: ancher) { [weak self] (string, error) in

        }
    }
}
