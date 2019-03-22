//
//  MainViewController.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

class MainViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let choiseGraph: Int = 4
    
    var dataGraph: [GraphInfo] = []
    var widthGraph: Double = 0
    let heightGraphView: CGFloat = 200
    let heightDateView: CGFloat = 50
    let minCountDay: Int = 30
    var isSetHeight: Bool = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateView: DateView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var graphViewSmall: GraphView!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func RangeSliderOutSide(_ sender: RangeSlider) {
        self.dateView.clearLabelsAplpha()
    }
    @IBAction func RangeSliderValueChanged(_ sender: RangeSlider) {
        
        if !sender.centerThumbLayer.highlighted{
            scaleWidth(width: Double(self.view.frame.width) * Double(1.0 / (sender.upperValue - sender.lowerValue)))
        }
        else{
            self.isSetHeight = false
        }
        self.scrollView.contentOffset.x = sender.lowerValue * self.scrollView.contentSize.width
        let contentIndex = scrollView.contentOffset.x
        self.graphView.scaleVerticalGraph(contentOfSet: contentIndex, viewWidth: self.scrollView.frame.width, isSetHeightOnly: sender.centerThumbLayer.highlighted)
        self.isSetHeight = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataJson = ParseJson()
        self.dataGraph = dataJson.getArrPoint()
        setGraph(n: self.choiseGraph)
    }
    
    private func createViewInContentView(){
        
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
        let contentOffSet: CGFloat = CGFloat(self.widthGraph) - self.scrollView.frame.width
        self.graphView.setPoints(graph: self.dataGraph[n], verticalGrid: true, contentOffSet: contentOffSet, width: self.scrollView.frame.width)
        self.graphViewSmall.setPoints(graph: self.dataGraph[n], isFullscreen: false)
        self.dateView.setDate(data: self.dataGraph[n])
        self.scrollView.setContentOffset(CGPoint(x: contentOffSet, y: 0), animated: true)
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
        if self.isSetHeight{
//            self.graphView.scaleVerticalGraph(contentOfSet: contentIndex, viewWidth: self.scrollView.frame.width, isSetHeightOnly: true)
        }
    }
    
    // Table View
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataGraph[self.choiseGraph].arrLineName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chCell", for: indexPath)
        cell.accessoryType = .checkmark
        cell.textLabel?.text = self.dataGraph[self.choiseGraph].arrLineName[indexPath.row]
        let viewToImage = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        viewToImage.backgroundColor = self.dataGraph[self.choiseGraph].arrLineColor[indexPath.row]
        viewToImage.layer.cornerRadius = viewToImage.frame.height / 2
        let image: UIImage = UIImage(view: viewToImage)
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}
