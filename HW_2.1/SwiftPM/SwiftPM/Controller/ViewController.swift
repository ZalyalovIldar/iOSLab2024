//
//  ViewController.swift
//  SwiftPM
//
//  Created by Damir Rakhmatullin on 18.03.25.
//

import UIKit
import MyCustomLogger
import SwiftyJSON

class ViewController: UIViewController {
    let dataManager = DataManager()
    private var tableViewDataSource: TableViewDataSource?
    
    lazy var mainView: View = {
        let view = View(frame: CGRect())
        return view
    }()
    
    override func loadView() {
        view = mainView
        MyCustomLogger.log("Это сообщение дебага", level: .debug)
        MyCustomLogger.log("Кастомный лог:", level: .warning)
        MyCustomLogger.log("Это информационное сообщение", level: .info)
        MyCustomLogger.log("Это предупреждение", level: .warning)
        MyCustomLogger.log("Это ошибка", level: .error)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        let data: [Tweet] = dataManager.loadJson()
        tableViewDataSource = TableViewDataSource(tableView: mainView.tableView)
        tableViewDataSource?.applySnapshot(data: data)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

