//
//  DataViewController.swift
//  training
//
//  Created by shota.nagao on 2017/08/31.
//  Copyright © 2017年 training. All rights reserved.
//

import UIKit
import RxSwift

class DataViewController: UITableViewController {

    fileprivate let Identifier: String = "Cell"
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: ListViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        fetch()
    }
    
    // MARK :
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier)
    }
    
    func setupViewModel() {
        viewModel.updateObservable.subscribe(onNext: { [weak self] updateType in
            switch updateType {
            case .success:
                self?.tableView.reloadData()
            case .failure(let messages):
                print(messages)
            }
        }).disposed(by: disposeBag)
    }
    
    func fetch() {
        self.viewModel.fetch()
    }
    
    // MARK : UITableViewDelegate and UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier)!
        cell.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 0.3)
        cell.textLabel?.text = viewModel.item(row: indexPath.row).body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let displayPosition: Int = indexPath.row
        if (displayPosition == self.viewModel.itemCount() - 1) {
            fetch()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.itemCount()
    }

}
