//
//  MainTabBarController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let viewModel = FinanceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController(viewModel: viewModel)
        let transactionsVC = TransactionViewController(viewModel: viewModel)
        let summaryVC = SummaryViewController(viewModel: viewModel)
        
        homeVC.title = "Home"
        transactionsVC.title = "Transactions"
        summaryVC.title = "Summary"

        let homeNav = UINavigationController(rootViewController: homeVC)
        let transactionsNav = UINavigationController(rootViewController: transactionsVC)
        let summaryNav = UINavigationController(rootViewController: summaryVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        transactionsNav.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "arrow.left.arrow.right"), selectedImage: nil)
        summaryNav.tabBarItem = UITabBarItem(title: "Summary", image: UIImage(systemName: "chart.pie"), selectedImage: nil)

        setViewControllers([homeNav, transactionsNav, summaryNav], animated: false)
        
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
    }
}

