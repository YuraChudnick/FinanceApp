//
//  ViewController.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit
import Alamofire
import AKMaskField

class MainVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainCost: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    @IBOutlet weak var lastOperationsView: UIView!
    
    lazy var noDataLabel: UILabel = {
        let l = UILabel()
        l.text = "Нет данных"
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont(name: "Roboto-Regular", size: 14)
        return l
    }()
    
    lazy var noDataLabel2: UILabel = {
        let l = UILabel()
        l.text = "Нет данных"
        l.textAlignment = .center
        l.textColor = .black
        l.font = UIFont(name: "Roboto-Regular", size: 14)
        return l
    }()
    
    var fundsList: [Fund] = [] {
        didSet {
            updateTableViewHeight()
            fundsTableView.reloadData()
            getLastOperations()
            getDisclaimers()
        }
    }
    var lastOperations: [FundOperation] = [] {
        didSet {
            operationsTableView.reloadData()
        }
    }
    var date: String = ""
    let cellId = "FundCell"
    let cellId2 = "FundOperationCell"
    
    let operationsGroup = DispatchGroup()
    let restApi = RestApi()
    
    @IBOutlet weak var fundsTableView: UITableView!
    @IBOutlet weak var operationsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var operationsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var disclaimerTextView: UITextView!
    @IBOutlet weak var disclaimerTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberTextField: AKMaskField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fundsActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var operationsActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var disclaimerActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainActivityIndicator.hidesWhenStopped = true
        fundsActivityIndicator.hidesWhenStopped = true
        operationsActivityIndicator.hidesWhenStopped = true
        disclaimerActivityIndicator.hidesWhenStopped = true
        
        phoneNumberView.addRoundedCorners(radius: 4)
        phoneNumberTextField.maskDelegate = self
        
        lastOperationsView.layer.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        disclaimerTextView.isScrollEnabled = false
        
        let leftButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = leftButton
        
        fundsTableView.backgroundColor = .clear
        fundsTableView.separatorColor = .clear
        fundsTableView.delegate = self
        fundsTableView.dataSource = self
        fundsTableView.tableFooterView = UIView(frame: .zero)
        fundsTableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        operationsTableView.delegate = self
        operationsTableView.dataSource = self
        operationsTableView.separatorColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 1, alpha: 1)
        operationsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        operationsTableView.tableFooterView = UIView(frame: .zero)
        operationsTableView.register(UINib(nibName: cellId2, bundle: nil), forCellReuseIdentifier: cellId2)
        
        getDate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailVC", let d = sender as? FundOperation {
            let vc = segue.destination as! DetailVC
            vc.operation = d
        }
    }
    
    @objc func getDate() {
        mainActivityIndicator.startAnimating()
        fundsActivityIndicator.startAnimating()
        operationsActivityIndicator.startAnimating()
        disclaimerActivityIndicator.startAnimating()
        restApi.getMaxDate { [weak self] (response) in
            switch response {
            case .success(let date):
                self?.date = date
                self?.updateData(date: date)
            case .error(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func updateData(date: String) {
        restApi.getPortfolioValue(date: date, currency: "RUB") { [weak self] (data) in
            self?.mainActivityIndicator.stopAnimating()
            if let value = data {
                self?.mainCost.text = Double(value.amount)!.formattedWithSeparator + " " + Utils.getCurrencySymbol(curr: value.currency)
            } else {
                self?.mainCost.text = "Нет данных"
            }
        }
        restApi.getPortfolio(date: date) { [weak self] (list) in
            self?.fundsActivityIndicator.stopAnimating()
            self?.fundsList = list
            if list.isEmpty { self?.fundsTableView.backgroundView = self?.noDataLabel }
        }
    }
    
    private func updateTableViewHeight() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.tableViewHeightConstraint.constant = CGFloat(self.fundsList.count * (74 + 10))
            self.view.layoutIfNeeded()
        }
    }
    
    private func getLastOperations() {
        var operations: [FundOperation] = []
        
        for i in fundsList {
            operationsGroup.enter()
            restApi.getFundOperations(fundId: i.id) { [weak self] (list) in
                guard let `self` = self else { return }
                var temp: [FundOperation] = []
                for var j in list {
                    j.fundName = i.name
                    temp.append(j)
                }
                operations += temp
                self.operationsGroup.leave()
            }
        }
        
        operationsGroup.notify(queue: .main) {
            self.operationsActivityIndicator.stopAnimating()
            self.lastOperations = operations.getLastFiveElements()
            if self.lastOperations.isEmpty { self.operationsTableView.backgroundView = self.noDataLabel }
        }
    }
    
    private func getDisclaimers() {
        let ids = fundsList.compactMap({ String($0.id) }).joined(separator: ",")
        restApi.getDisclaimers(fundIds: ids) { [weak self] (list) in
            self?.disclaimerActivityIndicator.stopAnimating()
            guard let `self` = self else { return }
            let text = list.map({ $0.text }).joined(separator: "\n")
            self.disclaimerTextView.text = text == "" ? "Нет данных" : text
            self.disclaimerTextView.textAlignment = text == "" ? .center : .left
            self.updateDisclamerHeight()
        }
    }
    
    private func updateDisclamerHeight() {
        let contentSize = disclaimerTextView.sizeThatFits(disclaimerTextView.bounds.size)
        UIView.animate(withDuration: 0.3) {
            self.disclaimerTextViewHeight.constant = contentSize.height + 40
            self.view.layer.layoutIfNeeded()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Сообщение", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] (action) in
            self?.getDate()
        }))
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { [weak self] (action) in
            self?.showNoData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showNoData() {
        mainActivityIndicator.stopAnimating()
        fundsActivityIndicator.stopAnimating()
        operationsActivityIndicator.stopAnimating()
        disclaimerActivityIndicator.stopAnimating()
        
        mainCost.text = "Нет данных"
        disclaimerTextView.text = "Нет данных"
        disclaimerTextView.textAlignment = .center
        fundsTableView.backgroundView = noDataLabel
        operationsTableView.backgroundView = noDataLabel2

    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.tag == 0 ? fundsList.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 1 : lastOperations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FundCell
            cell.initCell(date: date, data: fundsList[indexPath.section], restApi: restApi)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! FundOperationCell
            cell.initCell(operation: lastOperations[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            if let url = URL(string: fundsList[indexPath.section].link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            performSegue(withIdentifier: "ShowDetailVC", sender: lastOperations[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tag == 0 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.tag == 0 ? 74 : 64
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
}

extension MainVC: AKMaskFieldDelegate {
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        
        switch maskField.maskStatus {
        case .complete:
            nextButton.alpha = 1
        case .incomplete:
            nextButton.alpha = 0.3
        case .clear:
            nextButton.alpha = 0.3
        }
    }
    
}

