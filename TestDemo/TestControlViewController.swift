//
//  TestControlViewController.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/23.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TestControlViewController: UIViewController {

    fileprivate var disposeBag = DisposeBag()
    
    fileprivate let bbitem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Item", style: .plain, target: nil, action: nil)
        return item
    }()
    
    fileprivate let segmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegment(withTitle: "seg0", at: 0, animated: false)
        seg.insertSegment(withTitle: "seg1", at: 1, animated: false)
        return seg
    }()
    
    fileprivate let switchControl: UISwitch = {
        let s = UISwitch()
        return s
    }()
    
    fileprivate let activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.activityIndicatorViewStyle = .gray
        return a
    }()
    
    fileprivate let slider: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 1
        return s
    }()
    
    fileprivate let textField: UITextField = {
        let t = UITextField()
        t.font = UIFont.systemFont(ofSize: 15)
        t.borderStyle = .roundedRect
        return t
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .dateAndTime
        return date
    }()
    
    fileprivate let pan: UIPanGestureRecognizer = {
        let p = UIPanGestureRecognizer(target: nil, action: nil)
        return p
    }()
    
    
    fileprivate let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = bbitem
        
        _ = bbitem.rx.tap.subscribe(onNext: { (event) in
            print("---------------")
        })
        
        dd_layoutSubViews()
        dd_rxSwift()
    }
}


// MARK: - Rx
extension TestControlViewController {
    fileprivate func dd_rxSwift() {
        
        let _ = segmentControl.rx.value
            .subscribe(onNext: { x in
                print("segmentedValue is \(x)")
            })
            .addDisposableTo(disposeBag)
        
        _ = slider.rx.value
            .subscribe(onNext: { x in
                print("slider value is \(x)")
            })
            .addDisposableTo(disposeBag)
        
        _ = textField.rx.text
            .subscribe(onNext: { text in
                if let text = text {
                    print("textField value is \(text)")
                }
            })
            .addDisposableTo(disposeBag)
        
        _ = datePicker.rx.date
            .subscribe(onNext: { (date) in
                print("date value is \(date)")
            })
            .addDisposableTo(disposeBag)
        
        _ = textView.rx.text
            .subscribe(onNext: { text in
                if let text = text {
                    print("textView value is \(text)")
                }
            })
            .addDisposableTo(disposeBag)
        
        _ = pan.rx.event
            .subscribe(onNext: { [unowned self] (pan) in
                let point = pan.location(in: self.view)
                print("point value is \(point)")
            })
            .addDisposableTo(disposeBag)
        
        let textViewValid = textView.rx.text.orEmpty
            .map { $0.characters.count > 3 }
            .shareReplay(1)
        let everythingValid = Observable.combineLatest(switchControl.rx.value, textViewValid) { $0 && $1 }
            .shareReplay(1)
        
        _ = everythingValid
            .bindTo(activity.rx.isAnimating)
            .addDisposableTo(disposeBag)
    }
}


// MARK: - layoutSubViews
extension TestControlViewController {
    fileprivate func dd_layoutSubViews() {
        
        self.view.addGestureRecognizer(pan)

        self.view.addSubview(segmentControl)
        self.view.addSubview(switchControl)
        self.view.addSubview(activity)
        self.view.addSubview(slider)
        self.view.addSubview(textField)
        self.view.addSubview(datePicker)
        self.view.addSubview(textView)
        
        segmentControl.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(64)
            make.height.equalTo(44)
        }
        
        switchControl.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
        }
        
        activity.snp.makeConstraints { (make) in
            make.leading.equalTo(switchControl.snp.trailing).offset(20)
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
        }
        
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(switchControl.snp.bottom).offset(30)
        }
        
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.height.equalTo(64)
        }
    }
}

