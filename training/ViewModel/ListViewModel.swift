//
//  ListViewModel.swift
//  training
//
//  Created by shota.nagao on 2017/08/31.
//  Copyright © 2017年 training. All rights reserved.
//
import UIKit
import RxSwift
import APIKit

class ListViewModel: NSObject {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var list: [Repository] = []
    
    let updateObservable: PublishSubject<ResponseResult> = PublishSubject<ResponseResult>()
    
    func fetch() {
        let request: RepositoryRequest = RepositoryRequest()
        Session.send(request) { result in
            switch result {
            case .success(let response):
                self.list += response
                self.updateObservable.onNext(.success(response))
            case .failure(let error):
                self.updateObservable.onNext(.failure(error.localizedDescription))
            }
        }
    }
    
    func itemCount() -> Int {
        return list.count
    }
    
    func item(row: Int) -> Repository {
        return list[row]
    }

}

extension ListViewModel {
    
    enum ResponseResult {
        case success([Repository])
        case failure(String)
    }
    
}
