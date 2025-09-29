//
//  MainTabBarController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        let homeVC = HomeViewController()
        let transactionsVC = TransitionViewController()
        let summaryVC = SummaryViewController()
        
        homeVC.title = "Home"
        transactionsVC.title = "Transactions"
        summaryVC.title = "Summery"
        
        self.setViewControllers([
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: transactionsVC),
            UINavigationController(rootViewController: summaryVC)
        ], animated: false)
        
        guard let items = tabBar.items else { return }
        let icons = ["house", "arrow.left.arrow.right", "chart.pie"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: icons[i])
        }
    }
}
