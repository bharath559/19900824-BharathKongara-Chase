//
//  FlowCoordinator.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation
import UIKit
import SwiftUI

final class NavigationCoordinator {
    
    private let navigationController = UINavigationController()
    
    init() {
        setupInitialViewController()
    }
    
    private func setupInitialViewController() {
        let serviceManager = ServiceManager.shared
        let vc = UIHostingController(rootView: WelcomeView(repository: CityRepository(serviceManager: serviceManager), weatherRepository: WeatherRepository(serviceManager: serviceManager)))
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [vc]
    }
    
    public func initialViewController() -> UINavigationController {
        return navigationController
    }
    
}


