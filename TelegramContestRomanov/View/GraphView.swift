//
//  GraphView.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class GraphView: UIView, CAAnimationDelegate{
    
    
    
    let deltaHeihgt: CGFloat = 2;
    var shapeLayer: [CAShapeLayer] = []
    var path: [UIBezierPath] = []
    var arrPoint: [[CGPoint]] = []
    var graph: GraphInfo?
    var maxValueY: Int = 0
    var stepY: CGFloat = 0
    var stepX: Double = 0
    var isBusy: Bool = false
    let verticalScaleDurationWithWidth: Double = 0.001
    let verticalScaleDurationOnly: Double = 0.1
    var startWidth: CGFloat = 0
    var startStepY: CGFloat = 0
    var arrLabel: [UILabel] = []
    var arrLabelMaxCount: Int = 5
    let labelFontSize: CGFloat = 12
    let labelWidth: CGFloat = 50
    let labelHeight: CGFloat = 15
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        print("tap")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override var frame: CGRect{
        didSet{
            if self.arrLabel.count > 0{
                createStartCoord()
            }
        }
    }
    
    private func customInit() {
        createArrLabel()
        createStartCoord()
        addLabelInView()
    }
    
    private func createArrLabel(){
        print(self.arrLabelMaxCount)
        for _ in 0...self.arrLabelMaxCount - 1{
            let label: UILabel = UILabel()
            label.alpha = 1
            label.text = ""
            label.font = UIFont(name: "default", size: self.labelFontSize)
            label.frame.size = CGSize(width: self.labelWidth, height: self.labelHeight)
            label.textAlignment = .left
            self.arrLabel.append(label)
        }
    }
    
    private func createStartCoord(){
        let x: CGFloat = 20
        let yZero = yToRealPoint(value: 0)
        print("zero = ", yZero)
        let gridHeihgt = self.frame.height - self.deltaHeihgt - self.labelHeight
        let gridStep = gridHeihgt / 4.0
        var y: CGFloat = 0
        for i in 0...self.arrLabel.count - 1{
            arrLabel[i].frame.origin.x = x
            y = yZero - gridStep * CGFloat(i)
            arrLabel[i].frame.origin.y = y
            arrLabel[self.arrLabelMaxCount - 1 - i].text = String(Int(y))
            print(x, y)
        }
    }
    
    private func addLabelInView(){
        for i in 0...self.arrLabel.count - 1{
            addSubview(self.arrLabel[i])
        }
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
        let value = self.frame.height - self.deltaHeihgt - CGFloat(value) * stepY
        return CGFloat(value)
    }
    
    private func realPointToY(value: CGFloat) -> CGFloat{
        let y = (self.frame.height - self.deltaHeihgt - value) / CGFloat(stepY)
        return y
    }
    
    func setPoints(graph: GraphInfo){
        self.startWidth = self.frame.width
        self.graph = graph
        getMax()
        self.stepY = (self.frame.height - 2 * self.deltaHeihgt) / CGFloat(self.maxValueY)
        self.startStepY = self.stepY
        self.stepX = Double(self.frame.width) / Double((self.graph?.arrDayInfo.count)! - 1)
        for i in 0...(self.graph?.arrLineName.count)!-1{
            createGraph(nGraph: i)
        }
        
    }
    
    func setWidth(width: Double, height: Double, contentOfSet: CGFloat, viewWidth: CGFloat){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if self.graph != nil{
            self.stepX = Double(self.frame.width) / Double((self.graph?.arrDayInfo.count)! - 1)
            reloadGraphNoAnimation()
        }
    }
    
    private func reloadGraphNoAnimation(){
        for i in 0...(self.graph?.arrLineName.count)! - 1{
            self.shapeLayer[i].path = createPath(nGraph: i).cgPath
        }
    }
    
    private func reloadHeightScale(){
        for i in 0...(self.graph?.arrLineName.count)! - 1{
            self.shapeLayer[i].transform = CATransform3DMakeScale(1, CGFloat(self.stepY) / self.startStepY, 1)
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
    
    func scaleVerticalGraph(contentOfSet: CGFloat, viewWidth: CGFloat, isSetHeightOnly: Bool){
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
            self.stepY = (self.frame.height - 2 * self.deltaHeihgt) / CGFloat(self.maxValueY)
            if !isBusy{
                var duration = 0.0
                if isSetHeightOnly {
                    duration = self.verticalScaleDurationOnly
                }
                else{
                    duration = self.verticalScaleDurationWithWidth
                }
                reloadGraph(duration: duration)
//                reloadHeightScale()
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
