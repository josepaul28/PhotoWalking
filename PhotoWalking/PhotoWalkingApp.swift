//
//  PhotoWalkingApp.swift
//
//  Created by Paul Soto on 24/6/22.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        _ = LocationManagerImpl.shared
        return true
    }
}

@main
struct PhotoWalkingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            PhotosListAssembler.assemble()
        }
    }
}
