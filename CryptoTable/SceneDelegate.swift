//
//  SceneDelegate.swift
//  CryptoTable
//
//  Created by  Михаил on 22.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let builder = CryptoTableViewControllerBuilderImpl()
        let vc = builder.build()
        let navigationController = UINavigationController(rootViewController: vc)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Устанавливаем нужный цвет
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

protocol CryptoTableViewControllerBuildableProlocol {
    func build() -> UIViewController
}

final class CryptoTableViewControllerBuilderImpl: CryptoTableViewControllerBuildableProlocol {
    func build() -> UIViewController {
        let viewModel = CryptoTableViewModelImpl()
        let vc = CryptoTableViewController()
        vc.viewModel = viewModel
        return vc
    }
}
