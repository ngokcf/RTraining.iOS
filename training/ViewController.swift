//
//  ViewController.swift
//  training
//
//  Created by shota.nagao on 2017/08/25.
//  Copyright © 2017年 training. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    fileprivate let Identifier: String = "Cell"
    
    fileprivate var entryCount : Int = 0
    fileprivate var entries : [String] = [] {
        didSet {
            self.entryCount = entries.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEntries()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier)
    }
    
    func setupEntries() {
        entries.append(" Firebase Realtime Database ")
        entries.append(" Firebase Cloud Message")
    }
    
    // MARK : Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier)!
        cell.textLabel?.text = entries[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            self.navigationController?.pushViewController(SyncViewController.make(), animated: true)
        } else {
            print(" No Route ")
        }
    }

}

