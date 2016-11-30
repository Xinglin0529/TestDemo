//
//  SearchGitViewController.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/23.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SearchGitViewController: UIViewController {
    
    fileprivate let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        return t
    }()
    
    fileprivate let searchBar: UISearchBar = {
        let s = UISearchBar()
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.tableHeaderView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchGitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
