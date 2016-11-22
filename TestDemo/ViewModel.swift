//
//  ViewModel.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/22.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxDataSources

class ViewModel: NSObject {
    
    func getUsers() -> Observable<[SectionModel<String, User>]> {
        return Observable.create({ (observer) -> Disposable in
            let users = [
                User(flowersCount: 1, floweringCount: 1, screenName: "screen1"),
                User(flowersCount: 2, floweringCount: 2, screenName: "screen2"),
                User(flowersCount: 3, floweringCount: 3, screenName: "screen3"),
                User(flowersCount: 4, floweringCount: 4, screenName: "screen4"),
                User(flowersCount: 5, floweringCount: 5, screenName: "screen5")
            ];
            let sections = [SectionModel(model: "section1", items: users)]
            observer.onNext(sections)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
