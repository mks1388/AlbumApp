//
//  AppUtil.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

class AppUtil {
    static func getViewController(storyboardName: String = Constants.storyboardMain, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func getErrorView() -> ErrorViewInterface {
        return ErrorView(frame: .zero)
    }
}
