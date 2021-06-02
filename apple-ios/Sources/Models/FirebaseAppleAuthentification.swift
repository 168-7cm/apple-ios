//
//  FireBaseAuthentication.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/06/01.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
// CryptoKitを使用して一般的な暗号化操作を実行する
import CryptoKit

final class FirebaseAppleAuthentification: NSObject {

    static let shared = FirebaseAppleAuthentification()
    private var nonce: String? = nil
    private var anchor: ASPresentationAnchor? = nil
    private var completion: LoginResult?

    func login(ancher: ASPresentationAnchor, completion: LoginResult?) {

        // ログインリクエストごとにランダムな文字列「ナンス」を生成します。
        // ナンスは、取得した ID トークンが、当該アプリの認証リクエストへのレスポンスとして付与されたことを確認するために使用します。
        let nonce = self.randomString()
        self.nonce = nonce
        self.anchor = ancher
        self.completion = { completion?($0, $1); self.completion = nil }

        // AppleIDに基づいてユーザーを認証するためのリクエストを生成するメカニズム。
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        // 新しいAppleID 認証リクエストを作成します。
        let request = appleIDProvider.createRequest()

        // 認証時にユーザーに要求される連絡先情報。
        request.requestedScopes = [.fullName, .email]

        // ログインリクエストでナンスのSHA256ハッシュを送信する。
        request.nonce = sha256(nonce)

        // プロバイダーによって作成された承認要求を管理するコントローラー。
        let appleIDAuthorizationController = ASAuthorizationController(authorizationRequests: [request])

        // 承認コントローラーが承認の試行の成功または失敗について通知するデリゲート。
        appleIDAuthorizationController.delegate = self

        // システムがユーザーに承認インターフェイスを表示できる表示コンテキストを提供するデリゲート。
        appleIDAuthorizationController.presentationContextProvider = self

        // コントローラーの初期化中に指定された承認フローを開始します。
        appleIDAuthorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension FirebaseAppleAuthentification: ASAuthorizationControllerDelegate {

    // 承認が正常に完了したことをデリゲートに伝えます。
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            self.completion?(false, FirebaseAppleIDAuthorizationError.unexpectedError)
            return
        }

        // Firebaseクレデンシャルを初期化します。
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { [weak self] (result, error) in

            // サインインでエラー
            if let error = error {
                self?.completion?(false, FirebaseAppleIDAuthorizationError.unexpectedError)
                return
            }

            // ログインしているユーザー
            guard let currentUser = Auth.auth().currentUser else  {
                self?.completion?(false, FirebaseAppleIDAuthorizationError.userNotFound)
                return
            }

            self?.completion?(true, nil)
            return
        }
    }

    // 失敗した場合
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        switch error {
        case ASAuthorizationError.canceled:
            self.completion?(false, FirebaseAppleIDAuthorizationError.userLoginCancelled)
        default:
            self.completion?(false, FirebaseAppleIDAuthorizationError.unexpectedError)
        }
    }
}

extension FirebaseAppleAuthentification: ASAuthorizationControllerPresentationContextProviding {

    // どのウィンドウからコンテンツをユーザーに表示するかをデリゲートに指示します。
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.anchor!
    }
}

@available(iOS 13.0, *)
extension FirebaseAppleAuthentification {

    // 32桁のランダムな文字列を生成
    // adoped from https://firebase.google.com/docs/auth/ios/apple?hl=ja
    private func randomString(length: Int = 32) -> String {

        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {

            // このデータ型を使用して、0 ～ 255 の整数を値に保存できます。
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0

                // 暗号的に安全なランダムバイトの配列を生成します。
                // rnd => 使用する乱数ジェネレータオブジェクト。デフォルトの乱数ジェネレーターを使用するにはkSecRandomDefaultを指定します。
                // カウント => bytesパラメータが指す配列に返すランダムなバイト数。
                // バイト =>　関数が暗号的に安全なランダムバイトで埋める配列へのポインター。少なくとも countバイトを保持するのに十分な大きさの配列を使用してください。
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess { fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")}
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { return String(format: "%02x", $0) }.joined()
        return hashString
    }
}
