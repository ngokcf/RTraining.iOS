//
//  SyncViewController.swift
//  training
//
//  Created by shota.nagao on 2017/08/25.
//  Copyright © 2017年 training. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseDatabase


class SyncViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate let Identifier: String = "Cell"
    fileprivate let disposeBag = DisposeBag()
    
    private var reference : DatabaseReference!
    private var entries: [DataSnapshot] = []
    
    enum Ref {
        case list, count
        var uri: String {
            switch self {
            case .list:
                return "comment/1/list"
            case .count:
                return "comment/1/count"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupReference()
        setupTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK : private
    
    private func setupTextField() {
        textField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext:{ [weak self] () in
                self?.completeTextFieldEditing()
            }).addDisposableTo(disposeBag)
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier)
    }
    
    private func completeTextFieldEditing() {
        let text : String? = self.textField.text
        if let value = text, !value.isEmpty {
            addComment(value: value)
            self.textField.text = ""
        }
    }
    
    private func addComment(value: String) {
        self.listReference().childByAutoId().setValue(value)
    }
    
    private func removeComment(row: Int) {
        let snapshot: DataSnapshot = self.entries[row]
        self.listReference().child(snapshot.key).removeValue()
    }
    
    private func listReference() -> DatabaseReference {
        return self.reference.child(Ref.list.uri)
    }
    
    private func countReference() -> DatabaseReference {
        return self.reference.child(Ref.count.uri)
    }
    
    private func setupReference() {
        self.reference = Database.database().reference()
        
        self.listReference().observe(.childAdded, with: { [weak self] (snapshot) in
            let indexPath = IndexPath.init(row: 0, section: 0)
            self?.entries.insert(snapshot, at: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        })

        self.listReference().observe(.childRemoved, with: { [weak self] (snapshot) in
            if let index = self?.entries.index(where: { $0.key == snapshot.key }) {
                let indexPath: IndexPath = IndexPath.init(row: index, section: 0)
                self?.entries.remove(at: index)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        })
        
        self.countReference().observe(.value, with: { [weak self] (snapshat) in
            guard let value = snapshat.value as? Int else { return }
            self?.label.text = " Child Count = \(value)"
        })
    }
    
    // MARK : UITableViewDelegate && UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier)!
        let snapshot: DataSnapshot = entries[indexPath.row]
        cell.textLabel?.text = snapshot.value as? String
        cell.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 0.3)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.removeComment(row: indexPath.row)
    }
    
}

