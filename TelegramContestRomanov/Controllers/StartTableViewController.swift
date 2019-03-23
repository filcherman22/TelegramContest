//
//  StartTableViewController.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 22.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

protocol ChartDataProtocol {
    var choiseChart: GraphInfo!{
        get set
    }
}

class StartTableViewController: UITableViewController, ChartDataProtocol, Theme {
    
    var isDay: Bool!{
        didSet(old){
            UserDefaults.standard.set(self.isDay, forKey: "isDay")
            print("did set")
        }
    }
    
    var dataGraph: [GraphInfo] = []
    var choiseChart: GraphInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
//        self.isDay = UserDefaults.standard.bool(forKey: "isDay")
//        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isDay = UserDefaults.standard.bool(forKey: "isDay")
        setTheme(isDay: self.isDay)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataGraph.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chioseChartCell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + " chart"
        let theme = ThemeColors()
        let backView = UIView()
        if self.isDay{
            cell.textLabel?.textColor = theme.tintColorNight
            backView.backgroundColor = theme.backColorNight
            cell.backgroundColor = theme.frontColorNight
        }
        else{
            cell.textLabel?.textColor = theme.tintColorDay
            backView.backgroundColor = theme.backtColorDay
            cell.backgroundColor = theme.frontColorDay
        }
        cell.selectedBackgroundView = backView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.choiseChart = self.dataGraph[indexPath.row]
        performSegue(withIdentifier: "toViewGraph", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewGraph"{
            let list = segue.destination as! MainViewController
            list.choiseChart = self.choiseChart
        }
    }
    
    private func setTheme(isDay: Bool){
        let theme = ThemeColors()
        if !self.isDay{
            self.tableView.backgroundColor = theme.backtColorDay
            self.tableView.separatorColor = theme.backtColorDay
//            self.navigationController?.navigationBar.barTintColor = theme.frontColorDay
//            self.navigationController?.navigationBar.barStyle = .default
        }
        else{
            self.tableView.backgroundColor = theme.backColorNight
            self.tableView.separatorColor = theme.backColorNight
//            self.navigationController?.navigationBar.barTintColor = theme.frontColorNight
//            self.navigationController?.navigationBar.barStyle = .black
        }
        self.tableView.reloadData()
        
    }
    
}
