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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        
        let remoteURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings.json")!
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remotePropertyListingsLoader = RemotePropertyListingsLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemotePropertyListingsImageLoader(client: remoteClient)
        
        let localURL = Bundle.main.url(forResource: "SeLoger", withExtension: "realm")
        let realmConf = Realm.Configuration(fileURL: localURL)
        let localStore = RealmPropertyListingsStore(configuration: realmConf)
        let localPropertyListingsLoader = LocalPropertyListingsLoader(store: localStore)
        
        window?.rootViewController = PropertyListingsUIComposer.propertyListingsComposedWith(
            propertyListingsLoader: PropertyListingsLoaderWithFallbackComposite(
                primary: MainQueueDispatchDecorator(decoratee: remotePropertyListingsLoader),
                fallback: MainQueueDispatchDecorator(decoratee: localPropertyListingsLoader)),
            imageLoader: MainQueueDispatchDecorator(decoratee: remoteImageLoader))
        window?.makeKeyAndVisible()
    }

}

