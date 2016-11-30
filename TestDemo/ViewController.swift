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
//        testRxSwift5()
//        testRxSwift6()
//        testRxSwift7()
//        testRxSwift8()
//        testRxSwift9()
    }
}

extension ViewController {
    fileprivate func testRxSwift9() {
        ///Connectable Operator
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        _ = interval
//            .subscribe { print("connectable operator -- \($0)") }
//        delay(5) {
//            _ = interval.subscribe {
//                print("connectable operator -- \($0)")
//            }
//        }
        
        let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
        _ = intSequence.subscribe {
            print("Subscription1 -- \($0)")
        }
        
        delay(2) {
            _ = intSequence.connect()
        }
        
        delay(4) {
            _ = intSequence.subscribe {
                print("Subscription2 -- \($0)")
            }
        }
        
        delay(6) {
            _ = intSequence.subscribe {
                print("Subscription3 -- \($0)")
            }
        }
    }
}

extension ViewController {
    fileprivate func testRxSwift8() {
        /// reduce
        Observable.of(10, 100, 1000)
            .reduce(1, accumulator: +)
            .subscribe { print("reduce value is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///concat
        let subject1 = BehaviorSubject(value: "AA")
        let subject2 = BehaviorSubject(value: "BB")
        let variable = Variable(subject1)
        variable.asObservable()
            .concat()
            .subscribe { print("concat value is \($0)") }
            .addDisposableTo(disposeBag)
        subject1.on(.next("CC"))
        subject1.on(.next("DD"))
        variable.value = subject2
        subject2.on(.next("EE"))
        subject1.on(.next("GG"))
        subject2.on(.next("FF"))
        subject1.on(.next("HH"))
        subject1.on(.completed)
        print("\(#function), \(#line), \(#column)")
    }
}

extension ViewController {
    fileprivate func testRxSwift7() {
        /// of 可以把一系列元素转换成事件序列。
        /// filter 只会让符合条件的元素通过。
        Observable.of("🐱", "🐰", "🐶",
                      "🐸", "🐱", "🐰",
                      "🐹", "🐸", "🐱")
            .filter { $0 == "🐱" }
            .subscribe { print("filter value \($0)") }
            .addDisposableTo(disposeBag)
        
        ///distinctUntilChanged 会废弃掉重复的事件。
        Observable.of("1", "2", "3", "3", "4", "4", "5")
            .distinctUntilChanged()
            .subscribe { print("distinctUntilChanged value is \($0)")}
            .addDisposableTo(disposeBag)
        
        ///elementAt
        Observable.of("1", "2", "3", "4")
            .elementAt(2)
            .subscribe { print("elementAt value is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///single
        Observable.of("1", "2", "3", "4")
            .single { $0 == "3" }
            .subscribe { print("single value is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///take/takeLast 只获取序列中的前/后n个事件，在满足数量之后会自动 .Completed 。
        Observable.of("1", "2", "3", "4", "5")
            .takeLast(3)
            .map { "A\($0)" }
            .subscribe { print("take several values is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///takeWhile
        Observable.of(1,2,3,4,5,6,7)
            .takeWhile { $0 > 4 }
            .subscribe { print("take while values is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///takeUntil
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        sourceSequence
            .takeUntil(referenceSequence)
            .subscribe { print("takeUntil value is \($0)") }
            .addDisposableTo(disposeBag)
        sourceSequence.on(.next("A"))
        sourceSequence.on(.next("B"))
        sourceSequence.on(.next("C"))
        
        referenceSequence.on(.next("E"))
        
        sourceSequence.on(.next("X"))
        sourceSequence.on(.next("Y"))
        sourceSequence.on(.next("Z"))
        
        ///skip/skipWhile
        Observable.of(1,2,3,4,5,6)
            .skipWhile { $0 < 4 }
            .subscribe { print("skip vlaue is \($0)") }
            .addDisposableTo(disposeBag)
        
        ///skipUntil
        let sourceSequence1 = PublishSubject<String>()
        let referenceSequence1 = PublishSubject<String>()
        sourceSequence1
            .takeUntil(referenceSequence1)
            .subscribe { print("skipUntil value is \($0)") }
            .addDisposableTo(disposeBag)
        sourceSequence1.on(.next("A"))
        sourceSequence1.on(.next("B"))
        sourceSequence1.on(.next("C"))
        
        referenceSequence1.on(.next("E"))
        
        sourceSequence1.on(.next("X"))
        sourceSequence1.on(.next("Y"))
        sourceSequence1.on(.next("Z"))

    }
}

extension ViewController {
    fileprivate func testRxSwift6() {
        ///map 就是对每个元素都用函数做一次转换，挨个映射一遍。
        Observable.of(1,2,3,4)
            .map { $0 * 2}
            .subscribe {print("map value is \($0)")}
            .addDisposableTo(disposeBag)
        
        ///flatMap 在 Swift 中，我们可以用 flatMap 过滤掉 map 之后的 nil 结果。在 Rx 中， flatMap 可以把一个序列转换成一组序列，然后再把这一组序列『拍扁』成一个序列。
        struct Player {
            var score: Variable<Int>
        }
        
        let p1 = Player(score: Variable(80))
        let p2 = Player(score: Variable(90))
        let player = Variable(p1)
        player.asObservable()
            .flatMap { $0.score.asObservable() }
            .subscribe { print("flatMap value is \($0)") }
            .addDisposableTo(disposeBag)
        p1.score.value = 85
        player.value = p2
        p1.score.value = 95
        p2.score.value = 100
        
        ///scan 有点像 reduce ，它会把每次的运算结果累积起来，作为下一次运算的输入值。
        Observable.of(10, 100, 1000)
            .scan(1, accumulator: { total,newValue in
                total + newValue
            })
            .subscribe {
                print("scan value is \($0)")
            }
            .addDisposableTo(disposeBag)
    }
}

extension ViewController {
    fileprivate func testRxSwift5() {
        /// never 是没有任何元素、也不会发送任何事件的空序列。
        let disposeBag = DisposeBag()
        let neverSequence = Observable<String>.never()
        let neverSequenceSubscription = neverSequence
            .subscribe { _ in
                print("This will never be printed")
        }
        neverSequenceSubscription.addDisposableTo(disposeBag)
        
        ///empty 是一个空的序列，它只发送 .Completed 消息。
        _ = Observable<Int>.empty()
            .subscribe { (event) in
                print("empty event is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///just 是只包含一个元素的序列，它会先发送 .Next(value) ，然后发送 .Completed 。
        Observable.just("name")
            .subscribe { (event) in
                print("just value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///from 是把 Swift 中的序列 (SequenceType) 转换成事件序列。
        Observable.from(["A", "B"])
        .subscribe { (event) in
                print("from value is \(event)")
        }
        .addDisposableTo(disposeBag)
        
        ///repeatElement
        _ = Observable.repeatElement("H")
            .take(3)
            .subscribe { (event) in
                print("repeatElement is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        
        /// generate
        Observable.generate(initialState: 0, condition: { $0 < 3 }, iterate: { $0 + 1 })
            .subscribe { (event) in
                print("generate value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///deferrred 会等到有订阅者的时候再通过工厂方法创建 Observable 对象，每个订阅者订阅的对象都是内容相同而完全独立的序列。
        var count = 1
        let deferredSequence = Observable<String>.deferred {
            count += 1
            return Observable.create({ (observer) -> Disposable in
                observer.on(.next("A"))
                observer.on(.next("B"))
                return Disposables.create()
            })
        }
        
        deferredSequence
            .subscribe { (event) in
                print("defferred value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        deferredSequence
            .subscribe { (event) in
                print("defferred value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        
        ///error
        Observable<Int>.error(NSError(domain: "error", code: 111, userInfo: nil))
            .subscribe { (event) in
                print("error code is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///doOn
        Observable.of("a", "b", "c")
            .do(onNext: { (event) in
                print("intercepted \(event)")
            }, onError: { error in
                print("error is \(error)")
            }, onCompleted: {
                print("Completed")
            })
            .subscribe { (event) in
                print("on next is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        
        ///startWith 会在队列开始之前插入一个事件元素。
        Observable.of("A", "B", "C")
            .startWith("1")
            .startWith("2")
            .startWith("3")
            .subscribe { (event) in
                print("startWith value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///merge 把两个队列按照顺序组合在一起。
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        Observable.of(subject1, subject2)
            .merge()
            .subscribe { (event) in
                print("merge value is \(event)")
            }
            .addDisposableTo(disposeBag)
        subject1.on(.next("1"))
        subject2.on(.next("2"))
        
        ///zip 人如其名，就是合并两条队列用的，不过它会等到两个队列的元素一一对应地凑齐了之后再合并
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        Observable.zip(stringSubject, intSubject, resultSelector: { stringSubject, intSubject in
            "\(stringSubject)\(intSubject)"
        })
            .subscribe { (event) in
                print("zip value is \(event)")
            }
            .addDisposableTo(disposeBag)
        stringSubject.on(.next("A"))
        intSubject.on(.next(10))
        
        ///combineLatest 如果存在两条事件队列，需要同时监听，那么每当有新的事件发生的时候，combineLatest 会将每个队列的最新的一个元素进行合并。
        let stringSubject1 = PublishSubject<String>()
        let intSubject1 = PublishSubject<Int>()
        Observable.combineLatest(stringSubject1, intSubject1, resultSelector: { stringSubject, intSubject in
            "\(stringSubject)\(intSubject)"
        })
            .subscribe { (event) in
                print("combineLatest value is \(event)")
            }
            .addDisposableTo(disposeBag)
        stringSubject1.on(.next("A"))
        intSubject1.on(.next(10))
        
        ///Array.combineLatest
        let stringObservable = Observable.just("🌞")
        let fruitObservable = Observable.from(["🍏", "🍎"])
        let animalObservable = Observable.of("🐶", "🐱")
        Observable.combineLatest([stringObservable, fruitObservable, animalObservable]) {
                "\($0[0]) \($0[1]) \($0[2])"
            }
            .subscribe { (event) in
                print("Array.combineLatest value is \(event)")
            }
            .addDisposableTo(disposeBag)
        
        ///switchLatest 当你的事件序列是一个事件序列的序列 (Observable<Observable<T>>) 的时候，（可以理解成二维序列？），可以使用 switch 将序列的序列平铺成一维，并且在出现新的序列的时候，自动切换到最新的那个序列上。和 merge 相似的是，它也是起到了将多个序列『拍平』成一条序列的作用。
        /*
         example("switchLatest") {
         let var1 = Variable(0)
         let var2 = Variable(200)
         // var3 is like an Observable<Observable<Int>>
         let var3 = Variable(var1)
         let d = var3
         .switchLatest()
         .subscribe {
         print($0)
         }
         var1.value = 1
         var1.value = 2
         var1.value = 3
         var1.value = 4
         var3.value = var2
         var2.value = 201
         var1.value = 5
         var3.value = var1
         var2.value = 202
         var1.value = 6
         }
         --- switchLatest example ---
         Next(0)
         Next(1)
         Next(2)
         Next(3)
         Next(4)
         Next(200)
         Next(201)
         Next(5)
         Next(6)
         */
        let subjectBehavior1 = BehaviorSubject(value: "⚽️")
        let subjectBehavior2 = BehaviorSubject(value: "⚾️")
        let variable1 = Variable(subjectBehavior1)
        variable1.asObservable()
            .switchLatest()
            .subscribe { (event) in
                print("switchLatest value is \(event)")
            }
            .addDisposableTo(disposeBag)
        subjectBehavior1.on(.next("🏐"))
        subjectBehavior1.on(.next("🏉"))
        variable1.value = subjectBehavior2 //切换到subjectBehavior2
        subjectBehavior1.on(.next("🎱")) //不会发送
        subjectBehavior2.on(.next("🎾"))
        subjectBehavior1.on(.next("🏓")) //不会发送
        variable1.value = subjectBehavior1 //切换到subjectBehavior1
        subjectBehavior2.on(.next("22")) //不会发送
        subjectBehavior1.on(.next("11"))
    }
}


extension ViewController {
    fileprivate func testRxSwift4() {
        concat1()
//        _ = myJust(element: 3)
//            .subscribe { (event) in
//                print("myJust value === \(event)")
//            }
    }
    
    fileprivate func delay(_ delay: Double, closure: @escaping () -> ()) {
        let time = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
    }
    
    private func concat1() {
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
        b.value = 10
        delay(2) {
            f.value = "ddddd"
        }
    }
    
    ///create 可以通过闭包创建序列，通过 .on(e: Event) 添加事件。
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
        concat()
//        reduce()
    }
    
    /// 可以捕获异常事件，并且在后面无缝接上另一段事件序列，丝毫没有异常的痕迹。
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
    
    ///retry 顾名思义，就是在出现异常的时候会再去从头订阅事件序列，妄图通过『从头再来』解决异常。
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
            .retry()
            .subscribe { (event) in
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
    
    //doOn 可以监听事件，并且在事件发生之前调用。
    private func doOn() {
        let sequenceOfInts = PublishSubject<Int>()
        _ = sequenceOfInts.do(onNext: { (event) in
            
        })
        .subscribe(onNext: { (event) in
            
        })
        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.completed)
    }
    
    //takeUntil 其实就是 take ，它会在终于等到那个事件之后触发 .Completed 事件。
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
    
    ///takeWhile 通过状态语句判断是否继续 take 。
    private func takeWhile() {
        let sequence = PublishSubject<Int>()
        
        _ = sequence
            .takeWhile { $0 < 4 }
            .subscribe({ (event) in
                print(event)
            })
        sequence.on(.next(1))
    }
    
    ///concat 可以把多个事件序列合并起来。
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
    
    ///PublishSubject 会发送订阅者从订阅之后的事件序列。
    /*
     example("PublishSubject") {
     let subject = PublishSubject<String>()
     writeSequenceToConsole("1", sequence: subject)
     subject.on(.Next("a"))
     subject.on(.Next("b"))
     writeSequenceToConsole("2", sequence: subject)
     subject.on(.Next("c"))
     subject.on(.Next("d"))
     }
     --- PublishSubject example ---
     Subscription: 1, event: Next(a)
     Subscription: 1, event: Next(b)
     Subscription: 1, event: Next(c)
     Subscription: 2, event: Next(c)
     Subscription: 1, event: Next(d)
     Subscription: 2, event: Next(d)
     */
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
    
    ///ReplaySubject 在新的订阅对象订阅的时候会补发所有已经发送过的数据队列， bufferSize 是缓冲区的大小，决定了补发队列的最大值。如果 bufferSize 是1，那么新的订阅者出现的时候就会补发上一个事件，如果是2，则补两个，以此类推。
    /*
     example("ReplaySubject") {
     let subject = ReplaySubject<String>.create(bufferSize: 1)
     writeSequenceToConsole("1", sequence: subject)
     subject.on(.Next("a"))
     subject.on(.Next("b"))
     writeSequenceToConsole("2", sequence: subject)
     subject.on(.Next("c"))
     subject.on(.Next("d"))
     }
     --- ReplaySubject example ---
     Subscription: 1, event: Next(a)
     Subscription: 1, event: Next(b)
     Subscription: 2, event: Next(b) // 补了一个 b
     Subscription: 1, event: Next(c)
     Subscription: 2, event: Next(c)
     Subscription: 1, event: Next(d)
     Subscription: 2, event: Next(d)
     */
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
    
    ///BehaviorSubject 在新的订阅对象订阅的时候会发送最近发送的事件，如果没有则发送一个默认值。
    /*
     example("BehaviorSubject") {
     let subject = BehaviorSubject(value: "z")
     writeSequenceToConsole("1", sequence: subject)
     subject.on(.Next("a"))
     subject.on(.Next("b"))
     writeSequenceToConsole("2", sequence: subject)
     subject.on(.Next("c"))
     subject.on(.Completed)
     }
     --- BehaviorSubject example ---
     Subscription: 1, event: Next(z)
     Subscription: 1, event: Next(a)
     Subscription: 1, event: Next(b)
     Subscription: 2, event: Next(b)
     Subscription: 1, event: Next(c)
     Subscription: 2, event: Next(c)
     Subscription: 1, event: Completed
     Subscription: 2, event: Completed
     */
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
    
    ///Variable 是基于 BehaviorSubject 的一层封装，它的优势是：不会被显式终结。即：不会收到 .Completed 和 .Error 这类的终结事件，它会主动在析构的时候发送 .Complete 。
    /*
     example("Variable") {
     let variable = Variable("z")
     writeSequenceToConsole("1", sequence: variable)
     variable.value = "a"
     variable.value = "b"
     writeSequenceToConsole("2", sequence: variable)
     variable.value = "c"
     }
     --- Variable example ---
     Subscription: 1, event: Next(z)
     Subscription: 1, event: Next(a)
     Subscription: 1, event: Next(b)
     Subscription: 2, event: Next(b)
     Subscription: 1, event: Next(c)
     Subscription: 2, event: Next(c)
     Subscription: 1, event: Completed
     Subscription: 2, event: Completed
     */
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

