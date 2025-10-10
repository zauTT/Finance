//
//  SummaryViewController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import UIKit

class SummaryViewController: UIViewController {
    
    private let viewModel: FinanceViewModel
    
    private let balanceLabel = UILabel()
    private let incomeLabel = UILabel()
    private let expensesLabel = UILabel()
    private let tableView = UITableView()
    
    init(viewModel: FinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .astonMartinRacingGreen
        title = "Summery"
        
        [balanceLabel, incomeLabel, expensesLabel, tableView].forEach {
            view.addSubview($0)
        }
        
        setupUI()
        setupBindings()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBalanceVisibilityChanged(_:)), name: .balanceVisibilityChanged, object: nil)
    }
    
    private func setupUI() {
        balanceLabel.font = .boldSystemFont(ofSize: 32)
        balanceLabel.textAlignment = .center
        
        incomeLabel.textColor = .systemGreen
        expensesLabel.textColor = .systemRed
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .astonMartinRacingGreen
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.onTransactionsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    @objc private func handleBalanceVisibilityChanged(_ notification: Notification) {
        updateUI()
    }
    
    private func updateUI() {
        balanceLabel.text = BalanceVisibility.isHidden ? "Balance: ••••" : "Balance: \(String(format: "%.2f ₾", viewModel.totalBalance))"
        incomeLabel.text = "Income: +\(String(format: "%.2f ₾", viewModel.totalIncome))"
        expensesLabel.text = "Expenses: -\(String(format: "%.2f ₾", viewModel.totalExpenses))"
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safe = view.safeAreaInsets
        balanceLabel.frame = CGRect(x: 20, y: safe.top + 20, width: view.frame.width - 40, height: 40)
        incomeLabel.frame = CGRect(x: 20, y: balanceLabel.frame.maxY + 10, width: view.frame.width - 40, height: 30)
        expensesLabel.frame = CGRect(x: 20, y: incomeLabel.frame.maxY + 5, width: view.frame.width - 40, height: 30)
        tableView.frame = CGRect(x: 0, y: expensesLabel.frame.maxY + 10, width: view.frame.width, height: view.frame.height - expensesLabel.frame.maxY - 10)
    }
}

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categorySummary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.categorySummary[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let prefix = item.type == .income ? "+" : "-"
        cell.textLabel?.text = "\(item.category): \(prefix)\(String(format: "%.2f ₾", item.total))"
        
        cell.backgroundColor = .astonMartinRacingGreen
        cell.contentView.backgroundColor = .astonMartinRacingGreen
        cell.textLabel?.textColor = .white
        
        return cell
    }
}
