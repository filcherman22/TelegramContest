//
//  GraphView.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 10.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class GraphView: UIView, CAAnimationDelegate{
    
    
    
    var deltaHeihgt: CGFloat = 20
    var deltaHeightLower: CGFloat = 20
    let deltaLabelUpper: CGFloat = 5
    var shapeLayer: [CAShapeLayer] = []
    var path: [UIBezierPath] = []
    var graph: GraphInfo?
    var maxValueY: Int = 0
    var stepY: CGFloat = 0
    var stepX: Double = 0
    var isBusy: Bool = false
    let verticalScaleDurationWithWidth: Double = 0.001
    let verticalScaleDurationOnly: Double = 0.1
    var scrolViewWidth: CGFloat = 0
    var startWidth: CGFloat = 0
    var startStepY: CGFloat = 0
    var arrLabel: [UILabel] = []
    var arrCoordLabel: [CGPoint] = []
    var arrLineShape: [CAShapeLayer] = []
    let lineAlpha: Float = 0.2
    var lineWidht: CGFloat = 0.0
    var arrLabelMaxCount: Int = 5
    let labelFontSize: CGFloat = 12
    let labelWidth: CGFloat = 100
    let labelHeight: CGFloat = 15
    let labelAlpha: CGFloat = 0.5
    let leftWidthDelta: CGFloat = 0
    var verticalGrid: Bool = false
    var isFullScreen: Bool = true
    var arrHiddenNum: [Int] = []
    var verticalLineLayer: CAShapeLayer!
    var arrVerticalPointLayer: [CAShapeLayer] = []
    
    let labelInfoHeight: CGFloat = 15
    let labelInfoFontSize: CGFloat = 12
    let labelInfowidth: CGFloat = 50
    let labelInfoAlpha: Double = 1.0
    var viewInfo: UIView!
    let viewInfowidth: CGFloat = 100
    let labelInfoDateHeight: CGFloat = 50
    let labelInfoDateFontSize: CGFloat = 15
    var labelInfoDate: UILabel!
    var arrLabelInfoValues: [UILabel] = []
    
    // theme
    var viewInfoBackgroundColor: UIColor = UIColor()
    var colorTextLabelInfoDate: UIColor = UIColor()
    var colorTextLabel: UIColor = UIColor()
    var colorLine: UIColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startValue()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startValue()
    }
    
    private func defaultInit(){
        self.arrCoordLabel = Array(repeating: CGPoint(), count: self.arrLabel.count)
    }
    
    private func startValue(){
        setTheme(isDay: false)
        verticalLineLayerInit()
    }
    
    private func verticalGridInit() {
        createArrLabel()
        defaultInit()
    }
    
    private func createArrLabel(){
        self.arrLabel.removeAll()
        for _ in 0...self.arrLabelMaxCount - 1{
            let label: UILabel = UILabel()
            label.alpha = self.labelAlpha
            label.text = ""
            label.frame.size = CGSize(width: self.labelWidth, height: self.labelHeight)
            label.font = UIFont.systemFont(ofSize: self.labelFontSize)
            label.textColor = self.colorTextLabel
            label.textAlignment = .left
            self.arrLabel.append(label)
        }
    }
    
    private func createStartCoord(contentOffSet: CGFloat){
        let x: CGFloat = self.leftWidthDelta + contentOffSet
        let yZero = yToRealPoint(y: 0)
        let gridHeihgt = self.frame.height - self.deltaHeihgt - self.deltaHeightLower - self.labelHeight - self.deltaLabelUpper
        let gridStep = gridHeihgt / 4.0
        var y: CGFloat = 0
        for i in 0...self.arrLabel.count - 1{
            arrLabel[i].frame.origin.x = x
            y = yZero - gridStep * CGFloat(i)
            arrLabel[i].frame.origin.y = y
            arrLabel[i].text = String(Int(realPointToY(value: y)))
            self.arrCoordLabel[i] = CGPoint(x: x, y: y)
        }
    }
    
    private func createShapeLayers(width: CGFloat){
        self.arrLineShape.removeAll()
        for i in 0...self.arrCoordLabel.count - 1{
            self.arrLineShape.append(CAShapeLayer())
            self.arrLineShape[i].path = createLinesPath(i: i, x: 0.0).cgPath
            self.arrLineShape[i].strokeColor = self.colorLine.cgColor
            self.arrLineShape[i].fillColor = UIColor.clear.cgColor
            self.arrLineShape[i].lineWidth = 0.5
            self.arrLineShape[i].opacity = self.lineAlpha
            self.arrLineShape[i].position = CGPoint(x: 0, y: self.deltaHeihgt + self.deltaLabelUpper - 10)
        }
    }
    private func createLinesPath(i: Int, x: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x + self.leftWidthDelta, y: self.arrCoordLabel[i].y))
        path.addLine(to: CGPoint(x: x + self.lineWidht + self.leftWidthDelta, y: self.arrCoordLabel[i].y))
        return path
    }
    
    private func createFakeLinePath(i: Int, x: CGFloat, isScaleUpper: Bool) -> UIBezierPath{
        
        var n: CGFloat = 0
        if isScaleUpper{
            n = -1.0
        }
        else{
            n = 1.0
        }
        let path = UIBezierPath()
        let delta: CGFloat = 50.0
        path.move(to: CGPoint(x: x + self.leftWidthDelta, y: self.arrCoordLabel[i].y + delta * n))
        path.addLine(to: CGPoint(x: x + self.lineWidht + self.leftWidthDelta, y: self.arrCoordLabel[i].y + delta * n))
        return path
    }
    
    private func addShapeLayerInView(){
        for i in 0...self.arrLineShape.count - 1{
            self.layer.addSublayer(self.arrLineShape[i])
        }
    }
    
    private func addLabelInView(){
        for i in 0...self.arrLabel.count - 1{
            addSubview(self.arrLabel[i])
        }
    }
    
    private func setLabelX(contentOffSet: CGFloat){
        createStartCoord(contentOffSet: contentOffSet)
        for i in 0...self.arrLabel.count - 1{
            self.arrLineShape[i].path = createLinesPath(i: i, x: contentOffSet).cgPath
        }
    }
    
    private func setLabelValue(isScaleUpper: Bool){

        var n: CGFloat = 0
        if isScaleUpper{
            n = -1.0
        }
        else{
            n = 1.0
        }
        
        for i in 1...self.arrLabel.count - 1{
            self.arrLabel[i].alpha = 0
            self.arrLabel[i].frame.origin.y = self.arrCoordLabel[i].y + n * 50
            self.arrLabel[i].text = String(Int(realPointToY(value: self.arrCoordLabel[i].y)))
            UIView.animate(withDuration: 0.2) {
                self.arrLabel[i].alpha = self.labelAlpha
                self.arrLabel[i].frame.origin.y = self.arrCoordLabel[i].y
            }
        }
    }
    
    private func setLineValue(isScaleUpper: Bool, x: CGFloat){
        
        var arrPath: [UIBezierPath] = []
        for i in 0...self.arrLineShape.count - 1{
            arrPath.append(createLinesPath(i: i, x: x))
        }
        
        for i in 1...self.arrLineShape.count - 1{
            self.arrLineShape[i].path = createFakeLinePath(i: i, x: x, isScaleUpper: isScaleUpper).cgPath
            let animation: CABasicAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
            animation.duration = CFTimeInterval(0.2)
            animation.fromValue = self.arrLineShape[i].path
            self.arrLineShape[i].path = arrPath[i].cgPath
            animation.toValue = arrPath[i].cgPath
            self.arrLineShape[i].add(animation, forKey: nil)
            animation.delegate = self
        }
        

    }
    
    private func createPath(nGraph: Int) -> UIBezierPath{
        let path = UIBezierPath()
        let y = yToRealPoint(y: (self.graph?.arrDayInfo[0].arrY[nGraph])!)
        path.move(to: CGPoint(x: 0, y: y))
        for i in 1...(self.graph?.arrDayInfo.count)! - 1{
            path.addLine(to: CGPoint(x: xToRealPoint(x: i), y: yToRealPoint(y: (self.graph?.arrDayInfo[i].arrY[nGraph])!)))
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
    
    private func realPointToX(value: CGFloat) -> CGFloat{
        let x = value / CGFloat(stepX)
        return x
    }
    
    private func yToRealPoint(y: Int) -> CGFloat{
        let value = self.frame.height - self.deltaHeightLower - CGFloat(y) * stepY
        return CGFloat(value)
    }
    
    private func realPointToY(value: CGFloat) -> CGFloat{
        let y = (self.frame.height - self.deltaHeightLower - value) / CGFloat(stepY)
        return y
    }
    
    func setPoints(graph: GraphInfo, verticalGrid: Bool = false, contentOffSet: CGFloat = 0, isFullscreen: Bool = true, width: CGFloat){
        self.scrolViewWidth = width
        self.startWidth = self.frame.width
        self.graph = graph
        self.isFullScreen = isFullscreen
        self.verticalGrid  = verticalGrid
        getMax()
        if !self.isFullScreen{
            self.deltaHeihgt = 10
            self.deltaHeightLower = 2
        }
        self.stepY = (self.frame.height - 2 * self.deltaHeihgt) / CGFloat(self.maxValueY)
        self.startStepY = self.stepY
        self.stepX = Double(self.frame.width) / Double((self.graph?.arrDayInfo.count)! - 1)
        if verticalGrid {
            self.lineWidht = width
            verticalGridInit()
            createShapeLayers(width: width)
            addShapeLayerInView()
        }
        for i in 0...(self.graph?.arrLineName.count)!-1{
            createGraph(nGraph: i)
        }
        if verticalGrid{
            addLabelInView()
        }
        scaleVerticalGraph(contentOfSet: contentOffSet, viewWidth: width, isSetHeightOnly: true)
        if self.isFullScreen{
            initInfoView()
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
        var arrYValue: [Int] = []
        if startIndex < stopIndex{
            for i in startIndex...stopIndex{
                arrYValue = (self.graph?.arrDayInfo[i].arrY)!
                for el in self.arrHiddenNum{
                    arrYValue[el] = -1
                }
                maxVar = arrYValue.max()!
                    if maxVar > max{
                        max = maxVar
                    }
            }
            let oldMaxValue = self.maxValueY
            self.maxValueY = max
            self.stepY = (self.frame.height - self.deltaHeihgt - self.deltaHeightLower) / CGFloat(self.maxValueY)
            if self.verticalGrid{
                self.lineWidht = viewWidth - 2 * self.leftWidthDelta
                setLabelX(contentOffSet: contentOfSet)
                if self.maxValueY > oldMaxValue{
                    setLineValue(isScaleUpper: true, x: contentOfSet)
                    setLabelValue(isScaleUpper: true)
                }
                else if self.maxValueY < oldMaxValue{
                    setLineValue(isScaleUpper: false, x: contentOfSet)
                    setLabelValue(isScaleUpper: false)
                }
                
            }
            if !isBusy{
                var duration = 0.0
                if isSetHeightOnly {
                    duration = self.verticalScaleDurationOnly
                }
                else{
                    duration = self.verticalScaleDurationWithWidth
                }
                reloadGraph(duration: duration)
            }
        }
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isBusy = false
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        isBusy = true
    }
    
    func setGraphHidden(names: [String]){
        self.arrHiddenNum.removeAll()
        for name in names{
            let index = (self.graph?.arrLineName.firstIndex(of: name))
            if index != nil{
                self.arrHiddenNum.append(index!)
            }
        }
        hiddenLayers()
    }
    
    private func hiddenLayers(){
        for i in 0...self.shapeLayer.count - 1{
            if self.arrHiddenNum.firstIndex(of: i) != nil{
                self.shapeLayer[i].opacity = 0.0
            }
            else{
                self.shapeLayer[i].opacity = 1.0
            }
        }
    }
    
    // touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFullScreen{
            createNewInfoView()
//            setColorInfo()
            let x = (touches.first?.location(in: self).x)!
            setCoordInfo(x: x)
            setPointVertcalLine(x: x)
            updateViewInfo(x: x)
            setHiddenInfo(isHidden: false)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFullScreen{
//            setColorInfo()
            let x = (touches.first?.location(in: self).x)!
            setCoordInfo(x: x)
            setPointVertcalLine(x: x)
            updateViewInfo(x: x)
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFullScreen{
            setHiddenInfo(isHidden: true)
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func createVerticalLinePath(x: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: self.frame.height))
        return path
    }
    
    private func verticalLineLayerInit(){
        self.verticalLineLayer = CAShapeLayer()
        self.verticalLineLayer.strokeColor = self.colorLine.cgColor
        self.verticalLineLayer.fillColor = UIColor.clear.cgColor
        self.verticalLineLayer.lineWidth = 0.5
        self.verticalLineLayer.opacity = self.lineAlpha
        self.verticalLineLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(self.verticalLineLayer)
    }
    
    private func setCoordInfo(x: CGFloat){
        self.verticalLineLayer.path = createVerticalLinePath(x: x).cgPath
        let xView = x - self.viewInfo.frame.width / 2
        if xView < 0 {
            self.viewInfo.frame.origin = CGPoint(x: 0, y: 0)
        }
        else if xView > self.frame.width - self.viewInfo.frame.width{
            self.viewInfo.frame.origin = CGPoint(x: self.frame.width - self.viewInfo.frame.width, y: 0)
        }
        else{
            self.viewInfo.frame.origin = CGPoint(x: xView, y: 0)
        }
    }
    
    private func setHiddenInfo(isHidden: Bool){

        if isHidden{
            self.verticalLineLayer.opacity = 0.0
            for el in self.arrVerticalPointLayer{
                el.opacity = 0.0
            }
        }
        else{
            self.verticalLineLayer.opacity = self.lineAlpha
            for el in self.arrVerticalPointLayer{
                el.opacity = 1.0
            }
        }
        self.viewInfo.isHidden = isHidden
    }
    
    private func initInfoView(){
        self.viewInfo = UIView()
        self.addSubview(viewInfo)
        self.viewInfo.backgroundColor = self.viewInfoBackgroundColor
        self.viewInfo.layer.cornerRadius = 5
        self.viewInfo.frame = CGRect(x: 0, y: 0, width: self.viewInfowidth, height: 100)
        self.viewInfo.isHidden = true
        
        for i in 0...(self.graph?.arrLineName)!.count - 1{
            let label = UILabel()
            label.text = "69"
            label.textAlignment = .right
            label.textColor = self.graph?.arrLineColor[i]
            label.frame.size = CGSize(width: self.labelInfowidth, height: self.labelInfoHeight)
            label.font = UIFont.systemFont(ofSize: self.labelInfoFontSize)
            self.arrLabelInfoValues.append(label)
            self.viewInfo.addSubview(self.arrLabelInfoValues[i])
            
            let layer = CAShapeLayer()
            layer.strokeColor = self.graph?.arrLineColor[i].cgColor
            layer.fillColor = self.graph?.arrLineColor[i].cgColor
            layer.lineWidth = 2
            layer.opacity = 1.0
            layer.position = CGPoint(x: 0, y: 0)
            self.arrVerticalPointLayer.append(layer)
            self.layer.addSublayer(self.arrVerticalPointLayer[i])
        }
        
        self.labelInfoDate = UILabel()
        self.labelInfoDate.text = "Date"
        self.labelInfoDate.textAlignment = .left
        self.labelInfoDate.textColor = self.colorTextLabelInfoDate
        self.labelInfoDate.font = UIFont.systemFont(ofSize: self.labelInfoDateFontSize)
        self.labelInfoDate.frame.size = CGSize(width: self.viewInfowidth - self.labelInfowidth, height: self.labelInfoDateHeight)
        
        self.viewInfo.addSubview(self.labelInfoDate)
    }
    
    private func createNewInfoView(){
        let height: CGFloat!
        let count: Int = (self.graph?.arrLineName.count)! - self.arrHiddenNum.count
        if CGFloat(count) * self.labelInfoHeight > self.labelInfoDateHeight{
            height = CGFloat(count + 1) * self.labelInfoHeight
        }
        else{
            height = self.labelInfoDateHeight
        }
        self.viewInfo.frame.size = CGSize(width: self.viewInfowidth, height: height)
        self.labelInfoDate.frame.origin.x = 0
        self.labelInfoDate.frame.origin.y = self.viewInfo.frame.height / 2 - self.labelInfoDate.frame.height / 2
        
        let step = self.viewInfo.frame.height / CGFloat(count + 1)
        for i in 0...self.arrLabelInfoValues.count - 1{
            self.arrLabelInfoValues[i].frame.origin = CGPoint(x: self.viewInfo.frame.width - self.labelInfowidth, y: step + step * CGFloat(i) - self.labelInfoHeight / 2)
        }
    }
    
    private func setColors(){
        setColorInfo()
        for el in self.arrLabel{
            el.textColor = self.colorTextLabel
        }
        for el in self.arrLineShape{
            el.strokeColor = self.colorLine.cgColor
        }
        self.verticalLineLayer?.strokeColor = self.colorLine.cgColor
    }
    
    private func setColorInfo(){
        self.viewInfo?.backgroundColor = self.viewInfoBackgroundColor
        self.labelInfoDate?.textColor = self.colorTextLabelInfoDate
    }
    
    private func updateViewInfo(x: CGFloat){
        let j = lroundf(Float(realPointToX(value: x)))
        for i in 0...self.arrLabelInfoValues.count - 1{
            self.arrLabelInfoValues[i].text = String(self.graph!.arrDayInfo[j].arrY[i])
        }
        self.labelInfoDate.text = self.graph?.arrDayInfo[j].date.asString(style: .short)
    }
    
    private func setPointVertcalLine(x: CGFloat){
        let j: Int = lroundf(Float(realPointToX(value: x)))
        let diameter: CGFloat = 6.0
        for i in 0...self.arrVerticalPointLayer.count - 1{
            let realY: Int = (self.graph?.arrDayInfo[j].arrY[i])!
            let path = UIBezierPath(ovalIn: CGRect(x: CGFloat(xToRealPoint(x: j)) - diameter / 2, y: yToRealPoint(y: realY) - diameter / 2, width: diameter, height: diameter))
            self.arrVerticalPointLayer[i].path = path.cgPath
        }
        
    }
    
    func setTheme(isDay: Bool){
        let theme = ThemeColors()
        UIView.animate(withDuration: theme.duration) {
            if !isDay{
                self.viewInfoBackgroundColor = theme.backtColorDay
                self.colorTextLabelInfoDate = theme.tintColorDay
                self.backgroundColor = theme.frontColorDay
                self.colorTextLabel = theme.graphLabelsTextColorDay
                self.colorLine = theme.graphLabelsTextColorDay
            }
            else{
                self.viewInfoBackgroundColor = theme.backColorNight
                self.colorTextLabelInfoDate = theme.tintColorNight
                self.backgroundColor = theme.frontColorNight
                self.colorTextLabel = theme.graphLabelsTextColorNight
                self.colorLine = theme.graphLabelsTextColorNight
            }
        }
        setColors()
    }
}
