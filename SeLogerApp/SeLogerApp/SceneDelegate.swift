//
//  SceneDelegate.swift
//  SeLogerApp
//
//  Created by Romain Brunie on 25/04/2021.
//

import UIKit
import SeLogeriOS
import SeLoger
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var injectionContainer: AppDependencyContainer?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: RealmPropertyListingsStore = {
        let localURL = Bundle.main.url(forResource: "SeLoger", withExtension: "realm")
        let configuration = Realm.Configuration(fileURL: localURL)
        return RealmPropertyListingsStore(configuration: configuration)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        injectionContainer = AppDependencyContainer(httpClient: httpClient, store: store)
        
        window?.rootViewController = injectionContainer?.makePDLViewController() ?? UIViewController()

        window?.makeKeyAndVisible()
    }

}
