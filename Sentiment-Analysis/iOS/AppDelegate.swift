//
//  AppDelegate.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window!.tintColor = AppColor.neutral

        return true
    }
}
