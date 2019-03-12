//
//  GraphView.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    let deltaHeihgt: CGFloat = 30;
    var shapeLayer: [CAShapeLayer] = []
    var path: [UIBezierPath] = []
    var graph: GraphInfo?
    var arrData: [DayInfoUni] = []
    var maxValueY: Int = 0
    var stepY: Double = 0
    var stepX: Double = 0
    
    @IBOutlet var graphView: UIView!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + 50, height: self.frame.height)
        print("tap")
//        let scale = CGAffineTransform(scaleX: 2, y: 1)
        
//        let animation = CABasicAnimation(keyPath: <#T##String?#>)
//        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
//        createGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
//        createGraph()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("GraphView", owner: self, options: nil)
        addSubview(graphView)
        graphView.frame = self.bounds
        graphView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func createPath(nGraph: Int) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: yToRealPoint(value: (self.graph?.arrDayInfo[0].arrY[nGraph])!)))
        for i in 1...(self.graph?.arrDayInfo.count)! - 1{
            path.addLine(to: CGPoint(x: xToRealPoint(x: i), y: yToRealPoint(value: (self.graph?.arrDayInfo[i].arrY[nGraph])!)))
        }
        
        return path
    }
    
    private func createGraph(nGraph: Int){
        path.append(createPath(nGraph: nGraph))
        shapeLayer.append(CAShapeLayer())
        
        shapeLayer[nGraph].path = path[nGraph].cgPath
        
        shapeLayer[nGraph].strokeColor = self.graph?.arrLineColor[nGraph].cgColor
        shapeLayer[nGraph].fillColor = UIColor.clear.cgColor
        shapeLayer[nGraph].lineWidth = 2.0
        shapeLayer[nGraph].position = CGPoint(x: 0, y: 0)
        
        self.layer.addSublayer(shapeLayer[nGraph])
    }
    
    private func getMax(){
        var max = -1
        for el in self.arrData{
            let maxInArr = el.arrY.max()
            if max < maxInArr!{
                max = maxInArr!
            }
        }
        if self.maxValueY < max{
            self.maxValueY = max
        }
    }
    
    private func xToRealPoint(x: Int) -> CGFloat{
        return CGFloat(Double(x) * stepX)
    }
    
    private func yToRealPoint(value: Int) -> CGFloat{
        let value = self.frame.height - self.deltaHeihgt - CGFloat(Double(value) * stepY)
        return CGFloat(value)
    }
    
    func setPoints(graph: GraphInfo){
        self.graph = graph
        self.arrData = graph.arrDayInfo
        self.stepX = Double(self.frame.width) / Double(self.arrData.count - 1)
        getMax()
        self.stepY = Double(self.frame.height - 2 * self.deltaHeihgt) / Double(self.maxValueY)
        for i in 0...(self.graph?.arrLineName.count)!-1{
            createGraph(nGraph: i)
        }
        
    }
    
}
