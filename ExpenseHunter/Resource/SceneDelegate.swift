//
//  SceneDelegate.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        //let vc = UINavigationController(rootViewController: ViewController())
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }

}

