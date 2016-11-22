//
//  TestTableViewController.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/22.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class TestTableViewController: UIViewController {

    fileprivate let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    fileprivate let reuseIdentifier = "\(TableViewCell.self)"
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>()
    
    let disposeBag = DisposeBag()
    fileprivate let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        configCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TestTableViewController {
    fileprivate func configCell() {
        dataSource.configureCell = {_ , tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! TableViewCell
            cell.user = user
            return cell
        }
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        dataSource.canMoveRowAtIndexPath = { _, _ in
            return true
        }
        
        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        viewModel.getUsers()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}


extension TestTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("select indexPath value is \(dataSource.sectionModels[indexPath.section].items[indexPath.row].floweringCount)")
    }
}
