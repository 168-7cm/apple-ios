//
//  FirebaseAppleIDAuthrizationError.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/06/01.
//

import Foundation

enum FirebaseAppleIDAuthorizationError: Error {
    case unexpectedError
    case userNotFound
    case userLoginCancelled
}

extension FirebaseAppleIDAuthorizationError {
    
    var errorMessage: String {
        switch self {
        case .unexpectedError:
            return "予期せぬエラーが発生しました"
        case .userNotFound:
            return "ユーザーが見つかりません"
        case .userLoginCancelled:
            return "ログインをキャンセルしました"
        }
    }
}
