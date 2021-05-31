//
//  ViewControllerBase.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import UIKit

// ViewControllerの基底クラス
///
/// ViewControllerを作成する際に必ず継承するもの
/// ここに処理を記述する際は本当にここに書いた方がいいものなのかを考える

class ViewControllerBase: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// ViewBaseプロトコルを継承
extension ViewControllerBase: ViewBase {

}
