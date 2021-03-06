//
//  AppDelegate.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 25.11.2020.
//

import UIKit
import Swinject
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfigurationName = R.info.uiApplicationSceneManifest.uiSceneConfigurations.uiWindowSceneSessionRoleApplication.defaultConfiguration.uiSceneConfigurationName
        return UISceneConfiguration(name: sceneConfigurationName, sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

}
