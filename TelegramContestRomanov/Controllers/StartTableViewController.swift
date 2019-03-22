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

class StartTableViewController: UITableViewController, ChartDataProtocol {

    var dataGraph: [GraphInfo] = []
    var choiseChart: GraphInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        self.tableView.reloadData()
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
    
}
