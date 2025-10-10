//
//  HomeViewController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import UIKit

class HomeViewController: ViewController {
    
    private let viewModel: FinanceViewModel
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .astonMartinRacingGreen
        table.separatorColor = .white.withAlphaComponent(0.2)
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .singleLine
        return table
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        return button
    }()
    
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
        
        title = "Home"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: viewModel.isHidden ? "eye.slash" : "eye"),
            style: .plain,
            target: self,
            action: #selector(toggleHidden)
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(balanceLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.backgroundColor = .astonMartinRacingGreen
        
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        setupUI()
        setupBindings()
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBalanceVisibilityChanged(_:)), name: .balanceVisibilityChanged, object: nil)
        
        if viewModel.isHidden != BalanceVisibility.isHidden {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: BalanceVisibility.isHidden ? "eye.slash" : "eye")
            balanceLabel.text = BalanceVisibility.isHidden ? "••••" : "\(viewModel.totalBalance) ₾"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safe = view.safeAreaInsets
        balanceLabel.frame = CGRect(x: 20, y: safe.top + 20, width: view.frame.width - 40, height: 50)
        
        tableView.frame = CGRect(
            x: 0,
            y: balanceLabel.frame.maxY + 10,
            width: view.frame.width,
            height: view.frame.height - balanceLabel.frame.maxY - 100
        )
        
        addButton.frame = CGRect(
            x: view.frame.width - 76,
            y: view.frame.height - safe.bottom - 76,
            width: 56,
            height: 56
        )
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func setupBindings() {
        viewModel.onTransactionsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onVisibilityChanged = { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    @objc private func handleBalanceVisibilityChanged(_ notification: Notification) {
        let hidden = (notification.userInfo?["isHidden"] as? Bool) ?? BalanceVisibility.isHidden
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: hidden ? "eye.slash" : "eye")
        updateUI()
    }
    
    @objc private func toggleHidden() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        viewModel.toggleHidden()
        BalanceVisibility.isHidden = viewModel.isHidden
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: viewModel.isHidden ? "eye.slash" : "eye")
        updateUI()
    }
        
    @objc private func didTapAdd() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        tabBarController?.selectedIndex = 1
    }
    
    @objc private func updateUI() {
        let hidden = BalanceVisibility.isHidden
        balanceLabel.text = hidden ? "••••" : "\(viewModel.totalBalance) ₾"
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(viewModel.transactions.count, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = viewModel.transactions.reversed()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: transaction.date)
        let typeSymbol = transaction.type == .income ? "+" : "-"
        
        if BalanceVisibility.isHidden {
            cell.textLabel?.text = "\(transaction.category) ••• (\(dateString))"
        } else {
            cell.textLabel?.text = "\(transaction.category) \(typeSymbol)$\(transaction.amount) (\(dateString))"
        }
        
        cell.backgroundColor = .astonMartinRacingGreen
        cell.contentView.backgroundColor = .astonMartinRacingGreen
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

