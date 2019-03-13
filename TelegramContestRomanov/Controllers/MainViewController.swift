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
//            setSizeGraph(width: self.widthGraph)
        }
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - 100, y: 0), animated: true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        scaleWidth(width: self.widthGraph * Double(sender.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        setGraph(n: 0)
    }
    
    func setSizeGraph(width: Double){
        self.graphView.setWidth(width: width, height: Double(self.scrollView.frame.height), contentOfSet: self.scrollView.contentOffset.x, viewWidth: self.scrollView.frame.width)
        self.scrollView.contentSize = CGSize(width: CGFloat(width), height: self.scrollView.frame.height)
    }
    
    func setGraph(n: Int){
        self.widthGraph = Double(self.scrollView.frame.width) / 31 * Double(self.dataGraph[n].arrDayInfo.count - 1)
        setSizeGraph(width: self.widthGraph)
        self.graphView.setPoints(graph: self.dataGraph[n])
        self.scrollView.setContentOffset(CGPoint(x: self.widthGraph - Double(self.scrollView.frame.width), y: 0), animated: true)
    }
    
    func scaleWidth(width: Double){
        setSizeGraph(width: width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentIndex = scrollView.contentOffset.x
        if contentIndex < 0{
            self.scrollView.contentOffset.x = 0
        }
        if contentIndex > self.scrollView.contentSize.width - self.scrollView.frame.width{
            self.scrollView.contentOffset.x = self.scrollView.contentSize.width - self.scrollView.frame.width
        }
        self.graphView.scaleVerticalGraph(contentOfSet: contentIndex, viewWidth: self.scrollView.frame.width)
        
    }
    
    
}
