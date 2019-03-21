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
    let minCountDay: Int = 30
    var isSetHeight: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateView: DateView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var graphViewSmall: GraphView!
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    
    @IBAction func RangeSliderValueChanged(_ sender: RangeSlider) {
        isSetHeight = true
        scaleWidth(width: Double(self.view.frame.width) * Double(1.0 / (sender.upperValue - sender.lowerValue)))
        let contentIndex = scrollView.contentOffset.x
        self.graphView.scaleVerticalGraph(contentOfSet: contentIndex, viewWidth: self.scrollView.frame.width, isSetHeightOnly: false)
        self.scrollView.contentOffset.x = sender.lowerValue * self.scrollView.contentSize.width
        isSetHeight = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        setGraph(n: 0)
    }
    
    func setSizeGraph(width: Double){
        self.graphView.setWidth(width: width, height: Double(self.scrollView.frame.height - self.heightDateView), contentOfSet: self.scrollView.contentOffset.x, viewWidth: self.scrollView.frame.width)
        self.scrollView.contentSize = CGSize(width: CGFloat(width), height: self.scrollView.frame.height)
        self.dateView.setWidth(x: 0, y: self.scrollView.frame.height - self.heightDateView, width: CGFloat(width), height: self.heightDateView)
        
    }
    
    func setGraph(n: Int){
        self.widthGraph = Double(self.scrollView.frame.width) / Double(self.minCountDay) * Double(self.dataGraph[n].arrDayInfo.count - 1)
        self.rangeSlider.frame.size = CGSize(width: self.view.frame.width, height: self.rangeSlider.frame.height)
        self.rangeSlider.setPointsValue(lower: 1.0 - self.view.frame.width / CGFloat(self.widthGraph), upper: 1.0)
        setSizeGraph(width: self.widthGraph)
        self.graphView.setPoints(graph: self.dataGraph[n])
        self.graphViewSmall.setPoints(graph: self.dataGraph[n])
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
        if !isSetHeight{
            self.graphView.scaleVerticalGraph(contentOfSet: contentIndex, viewWidth: self.scrollView.frame.width, isSetHeightOnly: true)
        }
    }
    
    
}
