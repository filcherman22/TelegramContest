//
//  MainViewController.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UIScrollViewDelegate {
    
    var dataGraph: [GraphInfo] = []
    var widthGraph: Double = 0{
        didSet{
            print("did set widthGraph", self.widthGraph)
            setSizeGraph(width: self.widthGraph)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let width = Double(self.view.frame.width) * 2 * Double(sender.value)
        setSizeGraph(width: width)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        setGraph(n: 0)
        
    }
    
    func setSizeGraph(width: Double){
        self.graphView.frame = CGRect(x: 0, y: 0, width: width, height: Double(self.scrollView.frame.height))
        self.scrollView.contentSize = CGSize(width: CGFloat(width), height: self.scrollView.frame.height)
    }
    
    func setGraph(n: Int){
        self.widthGraph = Double(self.scrollView.frame.width) / 31 * Double(self.dataGraph[n].arrDayInfo.count - 1)
        self.scrollView.setContentOffset(CGPoint(x: self.widthGraph - Double(self.scrollView.frame.width), y: 0), animated: true)
        self.graphView.setPoints(graph: self.dataGraph[n])
    }

    
}
