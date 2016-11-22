//
//  TableViewCell.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/22.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var user: User? {
        willSet {
            let string = "\(newValue!.screenName)在简书上关注了\(newValue!.floweringCount)个用户，并且被\(newValue!.flowersCount)个用户关注了。"
            textLabel?.text = string
            textLabel?.numberOfLines = 0
        }
    }
    
}
