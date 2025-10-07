//
//  TransactionsViewController.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 29.09.25.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private let viewModel: FinanceViewModel
    
    init(viewModel: FinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let amountField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Amount"
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let typeSegment: UISegmentedControl = {
       let seg = UISegmentedControl(items: ["Income", "Expense"])
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    private let categoryField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Category (e.g. Food, Rent)"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let noteField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Note (Optional)"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let saveButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Save Transaction", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .astonMartinRacingGreen
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        view.backgroundColor = .astonMartinRacingGreen
        
        tableView.dataSource = self
        tableView.delegate = self
        
        [amountField, typeSegment, categoryField, noteField, saveButton, tableView].forEach {
            view.addSubview($0)
        }
        
        saveButton.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safe = view.safeAreaInsets
        let padding: CGFloat = 20
        let fieldHeight: CGFloat = 44
        let spacing: CGFloat = 12
        var yOffset = safe.top + padding
        
        amountField.frame = CGRect(x: padding, y: yOffset, width: view.frame.width - 2*padding, height: fieldHeight)
        yOffset += fieldHeight + spacing
        
        typeSegment.frame = CGRect(x: padding, y: yOffset, width: view.frame.width - 2*padding, height: fieldHeight)
        yOffset += fieldHeight + spacing
        
        categoryField.frame = CGRect(x: padding, y: yOffset, width: view.frame.width - 2*padding, height: fieldHeight)
        yOffset += fieldHeight + spacing
        
        noteField.frame = CGRect(x: padding, y: yOffset, width: view.frame.width - 2*padding, height: fieldHeight)
        yOffset += fieldHeight + spacing
        
        saveButton.frame = CGRect(x: padding, y: yOffset, width: view.frame.width - 2*padding, height: fieldHeight)
        yOffset += fieldHeight + padding
        
        tableView.frame = CGRect(x: 0, y: yOffset, width: view.frame.width, height: view.frame.height - yOffset)
    }
    
    //MARK: - Actions
    
    @objc private func saveTransaction() {
        guard let amountText = amountField.text,
                let amount = Double(amountText),
              !categoryField.text!.isEmpty else {
            showAlert(title: "Missing Info", message: "Please enter amount and category.")
            return
        }
        
        let type: TransactionType = typeSegment.selectedSegmentIndex == 0 ? .income : .expense
        
        let newTransaction = Transaction(
            id: UUID(),
            type: type,
            amount: amount,
            category: categoryField.text!,
            date: Date(),
            note: noteField.text
            )
        
        viewModel.addTransaction(newTransaction)

        amountField.text = ""
        categoryField.text = ""
        noteField.text = ""
        typeSegment.selectedSegmentIndex = 0
        
        tableView.reloadData()
        
        showAlert(title: "Success", message: "Transaction added!")
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = viewModel.transactions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: transaction.date)
        let sign = transaction.type == .income ? "+" : "-"
        
        if viewModel.isHidden {
            cell.textLabel?.text = "\(transaction.category) ••• (\(dateString))"
        } else {
            cell.textLabel?.text = "\(transaction.category) \(sign)$\(transaction.amount) (\(dateString))"
        }
        
        cell.backgroundColor = .astonMartinRacingGreen
        cell.contentView.backgroundColor = .astonMartinRacingGreen
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

