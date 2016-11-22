//
//  ViewController.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

let minimumUserNameLength = 5
let minimumPasswordLength = 5

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    fileprivate let userNameTextField: UITextField = {
        let t = UITextField()
        t.font = UIFont.systemFont(ofSize: 16)
        t.placeholder = "Input userName..."
        t.borderStyle = .roundedRect
        return t
    }()
    
    fileprivate let passwordTextField: UITextField = {
        let t = UITextField()
        t.font = UIFont.systemFont(ofSize: 16)
        t.placeholder = "Input password..."
        t.borderStyle = .roundedRect
        return t
    }()

    
    fileprivate let userNameWarnLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .left
        l.text = "userName has to be at least \(minimumUserNameLength) length"
        return l
    }()
    
    fileprivate let passwordWarnLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .left
        l.text = "password has to be at least \(minimumPasswordLength) length"
        return l
    }()
    
    fileprivate let commitButtom: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("Commit", for: .normal)
        b.setTitle("Commit", for: .disabled)
        b.setTitleColor(UIColor.green, for: .normal)
        b.setTitleColor(UIColor.black, for: .disabled)
        b.backgroundColor = .blue
        b.layer.cornerRadius = 10
        return b
    }()
    
    fileprivate let bindLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .left
        l.numberOfLines = 0
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        d_addSubViews()
        d_layoutSubviews()
        loginValidate()
        
//        testRxSwift1()
//        testRxSwift2()
//        testRxSwift3()
        testRxSwift4()
    }
}


extension ViewController {
    fileprivate func testRxSwift4() {
        concat()
//        _ = myJust(element: 3)
//            .subscribe { (event) in
//                print("myJust value === \(event)")
//            }
    }
    
    private func delay(delay: Double, closure: @escaping () -> ()) {
        let time = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
    }
    
    private func concat() {
        let a = Variable(1)
        let b = Variable(2)
        let f = Variable("sun->concat")
        
        _ = Observable
            .combineLatest(a.asObservable(), b.asObservable(), resultSelector: { (a, b) -> Int in
                return a + b
            })
            .map { String($0) }
            .concat(f.asObservable())
            .filter { $0.characters.count > 0 }
            .subscribe({ (event) in
                print("concat is --- \(event)")
            })
        a.value = 5
        delay(delay: 2) {
            f.value = "ddddd"
        }
    }
    
    private func myJust<E>(element: E) -> Observable<E> {
        return Observable.create({ (observe) -> Disposable in
            observe.on(.next(element))
            observe.on(.completed)
            return Disposables.create()
        })
    }
    
//    private func myInterval(interval: TimeInterval) -> Observable<Int> {
//        return Observable.create({ (observe) -> Disposable in
//            let queue = DispatchQueue.global(qos: .utility)
//        })
//    }
    
}

extension ViewController {
    fileprivate func testRxSwift3() {
//        catchErrorAndRecover()
//        catchErrorAndReturnJust()
//        retryAgain()
//        subscriptCompleted()
        reduce()
    }
    
    private func catchErrorAndRecover() {
        let sequenceThatFails = PublishSubject<Int>()
        let recoverySequence = Observable.of(100, 200, 300)
        
        _ = sequenceThatFails
            .catchError({ (error) -> Observable<Int> in
                return recoverySequence
            })
            .subscribe {
                print("catch error -- \($0)")
            }
        sequenceThatFails.on(.next(1))
        sequenceThatFails.on(.next(2))
        sequenceThatFails.on(.error(NSError(domain: "error", code: 0, userInfo: nil)))
        sequenceThatFails.on(.next(3))
    }
    
    private func catchErrorAndReturnJust() {
        let sequenceThatFails = PublishSubject<Int>()
        _ = sequenceThatFails.catchErrorJustReturn(100)
            .subscribe({ (event) in
                print("catch error is -- \(event)")
            })
        sequenceThatFails.on(.next(1))
        sequenceThatFails.on(.next(2))
        sequenceThatFails.on(.error(NSError(domain: "error", code: 0, userInfo: nil)))
        sequenceThatFails.on(.next(3))
    }
    
    private func retryAgain() {
        var count = 1
        let _ = Observable<Int>.create { (observe) -> Disposable in
            let error = NSError(domain: "error", code: 1, userInfo: nil)
            observe.on(.next(0))
            observe.on(Event.next(1))
            observe.on(Event.next(2))
            
            if count < 2 {
                observe.on(Event.error(error))
                count += 1
            }
            
            observe.on(.next(4))
            observe.on(.next(5))
            observe.on(.completed)
            return Disposables.create()
        }
            .retry().subscribe { (event) in
                print("retry is \(event)")
        }
    }
    
    private func subscriptCompleted() {
        let sequenceOfInts = PublishSubject<Int>()
        _ = sequenceOfInts
            .subscribe(onNext: { (event) in
                print("next value is \(event)")
            }, onCompleted: {
                print("onCompleted")
            })
        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.completed)
    }
    
    private func doOn() {
        let sequenceOfInts = PublishSubject<Int>()
        _ = sequenceOfInts.do(onNext: { (event) in
            
        })
        .subscribe(onNext: { (event) in
            
        })
        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.completed)
    }
    
    private func takeUntil() {
        let originalSequence = PublishSubject<Int>()
        let whenThisSendsNextWorldStops = PublishSubject<Int>()
        _ = originalSequence
            .takeUntil(whenThisSendsNextWorldStops)
            .subscribe({ (event) in
                print(event)
            })
        
        originalSequence.on(.next(1))
        whenThisSendsNextWorldStops.on(.next(6))
        originalSequence.on(.next(2))
    }
    
    private func takeWhile() {
        let sequence = PublishSubject<Int>()
        
        _ = sequence
            .takeWhile { $0 < 4 }
            .subscribe({ (event) in
                print(event)
            })
        sequence.on(.next(1))
    }
    
    private func concat() {
        let var1 = BehaviorSubject(value: 0)
        let var2 = BehaviorSubject(value: 100)
        let var3 = BehaviorSubject(value: var1)
        
        _ = var3
            .concat()
            .subscribe { (event) in
                print(event)
        }
        var1.on(.next(1))
        var1.on(.next(2))
        var1.on(.next(3))
        var1.on(.next(4))
        
        var3.on(.next(var2))
        
        var2.on(.next(201))
        
        var1.on(.next(5))
        var1.on(.next(6))
        var1.on(.next(7))
        var1.on(.completed)
        
        var2.on(.next(202))
        var2.on(.next(203))
        var2.on(.next(204))
    }
    
    private func reduce() {
        _ = Observable.of(1,2,3,4,5,6,7)
            .reduce(0, accumulator: { $0 + $1 })
            .subscribe({ (event) in
                print("reduce value === \(event)")
            })
    }
}

extension ViewController {
    fileprivate func testRxSwift2() {
        testMap()
    }
    
    private func  testMap() {
        let originalSequence = Observable.of(Character("A"), Character("B"), Character("C"))
        _ = originalSequence
            .map { $0.hashValue }
            .subscribe(onNext: { (vc) in
                print("value of map is \(vc)")
            })
    }
}


extension ViewController {
    fileprivate func testRxSwift1() {
//        createSequence()
//        ofSequence()
//        deferSequence()
//        publishSubject()
//        replaySubject()
//        behaviorSubject()
        variableSequence()
    }
    
    private func createSequence() {
        let create = {(element: Int) -> Observable<Int> in
            return Observable.create({ (observe) -> Disposable in
                observe.on(.next(element))
                observe.on(.completed)
                return Disposables.create()
            })
        }
        let _ = create(5).subscribe { (event) in
            print("test create is \(event)")
        }
    }
    
    private func ofSequence() {
        let sequenceElements = Observable.of(1,2,3,4,5)
        let _ = sequenceElements.subscribe { (event) in
            print("test of -- \(event)")
        }
    }
    
    private func deferSequence() {
        let deferSequence: Observable<Int> = Observable.deferred {
            return Observable.create({ (observe) -> Disposable in
                observe.on(.next(0))
                observe.on(.next(1))
                observe.on(.next(2))
                return Disposables.create()
            })
        }
        
        _ = deferSequence.subscribe(onNext: { (event) in
            print("test defer -- \(event)")
        })
    }
    
    
    private func publishSubject() {
        let subject = PublishSubject<String>()
        subject.on(.next("0"))
        _ = subject.subscribe { (event) in
            print("test publish 1-- \(event)")
        }
        
        subject.on(.next("a"))
        _ = subject.subscribe { (event) in
            print("test publish 2-- \(event)")
        }
        
        subject.on(.next("b"))
        _ = subject.subscribe(onNext: { (event) in
            print("test publish 3-- \(event)")
        })
        
        subject.on(.next("c"))
        subject.addDisposableTo(disposeBag)
    }
    
    private func replaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 1)
        subject.on(.next("0"))
        _ = subject.subscribe { (event) in
            print("test publish 1-- \(event)")
        }
        
        subject.on(.next("a"))
        _ = subject.subscribe { (event) in
            print("test publish 2-- \(event)")
        }
        
        subject.on(.next("b"))
        _ = subject.subscribe(onNext: { (event) in
            print("test publish 3-- \(event)")
        })
        
        subject.on(.next("c"))
        subject.addDisposableTo(disposeBag)
    }
    
    private func behaviorSubject() {
        let subject = BehaviorSubject(value: "z")
        subject.on(.next("0"))
        subject.on(.next("1"))
        _ = subject.subscribe { (event) in
            print("test behavior 1 -- \(event)")
        }
        subject.on(.next("2"))
        subject.on(.next("3"))
        _ = subject.subscribe { (event) in
            print("test behavior 2 -- \(event)")
        }
        
        subject.on(.next("4"))
        subject.on(.completed)
        subject.addDisposableTo(disposeBag)
    }
    
    private func variableSequence() {
        let variable = Variable("z")
        _ = variable.asObservable().subscribe(onNext: { (event) in
            print("test variable 1 --> \(event)")
        })
        variable.value = "a"
        variable.value = "b"
        
        _ = variable.asObservable().subscribe(onNext: { (event) in
            print("test variable 2 --> \(event)")
        })
        
        variable.value = "c"
        variable.value = "d"
    }
    
}

extension ViewController {
    fileprivate func loginValidate() {
        let userNameValid = userNameTextField.rx.text.orEmpty
            .map { $0.characters.count >= minimumUserNameLength }
            .shareReplay(1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.characters.count >= minimumPasswordLength }
            .shareReplay(1)
        
        let everyThingValid = Observable.combineLatest(userNameValid, passwordValid) { $0.0 && $0.1 }
            .shareReplay(1)
        
        userNameValid
            .bindTo(passwordTextField.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        userNameValid
            .bindTo(userNameWarnLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        passwordValid
            .bindTo(passwordWarnLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        everyThingValid
            .bindTo(commitButtom.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        _ = userNameTextField.rx.text
            .bindTo(bindLabel.rx.text)
        
        commitButtom.rx.tap
            .subscribe(onNext: { [weak self] in self?.showAlert() })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func showAlert() {
        let action = UIAlertAction(title: "确定", style: .default, handler: { [weak self] action in
            self?.navigationController?.pushViewController(TestTableViewController(), animated: true)
        })
        let alert = UIAlertController(title: "提示", message: "登录成功", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    fileprivate func d_addSubViews() {
        self.view.addSubview(userNameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(userNameWarnLabel)
        self.view.addSubview(passwordWarnLabel)
        self.view.addSubview(commitButtom)
        
        self.view.addSubview(bindLabel)
    }
}


extension ViewController {
    fileprivate func d_layoutSubviews() {
        userNameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(64 + 44)
            make.height.equalTo(44)
        }
        
        userNameWarnLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom).offset(5)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(userNameTextField)
            make.top.equalTo(userNameWarnLabel.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        
        passwordWarnLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(userNameTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
        }
        
        commitButtom.snp.makeConstraints { (make) in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(passwordWarnLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        bindLabel.snp.makeConstraints { (make) in
            make.top.equalTo(commitButtom.snp.bottom).offset(20)
            make.leading.trailing.equalTo(userNameTextField)
        }
    }
}

