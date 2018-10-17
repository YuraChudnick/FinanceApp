//
//  FundsView.swift
//  FinanceApp
//
//  Created by yura on 13.08.2018.
//  Copyright © 2018 yura. All rights reserved.
//

import UIKit

class FundsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "FundCell"
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        return t
    }()
    
    var fundsList: [Fund] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: topAnchor),
                                     tableView.leftAnchor.constraint(equalTo: leftAnchor),
                                     tableView.rightAnchor.constraint(equalTo: rightAnchor),
                                     tableView.heightAnchor.constraint(equalToConstant: 200)])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fundsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FundCell
        cell.name.text = fundsList[indexPath.section].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: fundsList[indexPath.section].link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
