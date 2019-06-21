//
//  AppRouter.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

protocol AppRouterInterface {
    func showDetail(parent: UINavigationController, child: UIViewController)
}

class AppRouter: AppRouterInterface {
    func showDetail(parent: UINavigationController, child: UIViewController) {
        parent.pushViewController(child, animated: true)
    }
}
