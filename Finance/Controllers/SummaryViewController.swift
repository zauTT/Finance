//
//  SummaryViewController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import UIKit

class SummaryViewController: UIViewController {
    
    private let viewModel: FinanceViewModel
    
    init(viewModel: FinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
