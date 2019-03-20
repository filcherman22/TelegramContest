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
    var widthGraph: Double = 0
    let heightGraphView: CGFloat = 200
    let heightDateView: CGFloat = 50
    
    @IBAction func tapButton(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - 100, y: 0), animated: true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateView: DateView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        scaleWidth(width: self.widthGraph * Double(sender.value))
    }
    @IBAction func RangeSliderValueChanged(_ sender: RangeSlider) {
        print(sender.lowerValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        setGraph(n: 1)
    }
    
    func setSizeGraph(width: Double){
        self.graphView.setWidth(width: width, height: Double(self.scrollView.frame.height - self.heightDateView), contentOfSet: self.scrollView.contentOffset.x, viewWidth: self.scrollView.frame.width)
        self.dateView.setWidth(x: 0, y: self.scrollView.frame.height - self.heightDateView, width: CGFloat(width), height: self.heightDateView)
        self.scrollView.contentSize = CGSize(width: CGFloat(width), height: self.scrollView.frame.height)
    }
    
    func setGraph(n: Int){
        self.widthGraph = Double(self.scrollView.frame.width) / 31 * Double(self.dataGraph[n].arrDayInfo.count - 1)
        setSizeGraph(width: self.widthGraph)
        self.graphView.setPoints(graph: self.dataGraph[n])
        self.dateView.setDate(data: self.dataGraph[n])
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
