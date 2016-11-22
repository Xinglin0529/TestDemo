//
//  MYView.swift
//  MYViewDemo
//
//  Created by Dongdong on 16/11/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class MYView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
