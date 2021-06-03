//
//  ViewControllerBase.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import UIKit
import Toast_Swift

// ViewControllerの基底クラス
///
/// ViewControllerを作成する際に必ず継承するもの
/// ここに処理を記述する際は本当にここに書いた方がいいものなのかを考える

class ViewControllerBase: UIViewController {

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// ViewBaseプロトコルを継承
extension ViewControllerBase: ViewBase {
    func showToast(message: String) {
        self.view.makeToast(message)
    }

    func beginActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func endActivityIndicator() {
        self.activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}
