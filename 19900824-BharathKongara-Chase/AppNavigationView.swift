//
//  AppNavigationView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation
import SwiftUI
import UIKit

struct AppNavigationView: UIViewControllerRepresentable {
    private let navigationCoordinator = NavigationCoordinator()
    func makeUIViewController(context: Context) -> UINavigationController {
        navigationCoordinator.initialViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        //no-op
    }
}
