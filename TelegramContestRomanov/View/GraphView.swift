//
//  GraphView.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class GraphView: UIView, CAAnimationDelegate{
    
    
    
    let deltaHeihgt: CGFloat = 30;
    var shapeLayer: [CAShapeLayer] = []
    var path: [UIBezierPath] = []
    var arrPoint: [[CGPoint]] = []
    var graph: GraphInfo?
    var maxValueY: Int = 0
    var stepY: Double = 0
    var stepX: Double = 0
    var isBusy: Bool = false
    let verticalScaleDuration: Double = 0.2
    
    @IBOutlet var graphView: UIView!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
//        self.stepY = self.stepY - 1
//        reloadGraph(duration: 3)
        print("tap")
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
        let y = yToRealPoint(value: (self.graph?.arrDayInfo[0].arrY[nGraph])!)
        path.move(to: CGPoint(x: 0, y: y))
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
        for el in (self.graph?.arrDayInfo)!{
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
        getMax()
        self.stepY = Double(self.frame.height - 2 * self.deltaHeihgt) / Double(self.maxValueY)
        self.stepX = Double(self.frame.width) / Double((self.graph?.arrDayInfo.count)! - 1)
        for i in 0...(self.graph?.arrLineName.count)!-1{
            createGraph(nGraph: i)
        }
        
    }
    
    func setWidth(width: Double, height: Double, contentOfSet: CGFloat, viewWidth: CGFloat){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if self.graph != nil{
            
            self.stepX = Double(self.frame.width) / Double((self.graph?.arrDayInfo.count)! - 1)
//            scaleVerticalGraph(contentOfSet: contentOfSet, viewWidth: viewWidth)
            reloadGraph(duration: 0)
        }
    }
    
    private func reloadGraph(duration: Double){
        for i in 0...(self.graph?.arrLineName.count)! - 1{
            let animation: CABasicAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
            let path: UIBezierPath = createPath(nGraph: i)
            animation.duration = CFTimeInterval(duration)
            animation.fromValue = shapeLayer[i].path
            self.shapeLayer[i].path = path.cgPath
            self.path[i] = path
            animation.toValue = path
            animation.delegate = self
            shapeLayer[i].add(animation, forKey: nil)
        }
        
        
    }
    
    func scaleVerticalGraph(contentOfSet: CGFloat, viewWidth: CGFloat){
        var startIndex: Int = Int(Double(contentOfSet) / self.stepX) - 1
        if startIndex < 0{
            startIndex = 0
        }
        var stopIndex: Int = Int(Double(viewWidth) / self.stepX) + 3 + startIndex
        if stopIndex >= (self.graph?.arrDayInfo.count)! - 1{
            stopIndex = (self.graph?.arrDayInfo.count)! - 1
        }
        var max: Int = -1
        var maxVar:Int = 0
        if startIndex < stopIndex{
            for i in startIndex...stopIndex{
                maxVar = (self.graph?.arrDayInfo[i].arrY.max())!
                if maxVar > max{
                    max = maxVar
                }
            }
            self.maxValueY = max
            self.stepY = Double(self.frame.height - 2 * self.deltaHeihgt) / Double(self.maxValueY)
            if !isBusy{
                reloadGraph(duration: verticalScaleDuration)
            }
        }
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isBusy = false
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        isBusy = true
    }
    
    
}
