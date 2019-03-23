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

class MainViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ChartDataProtocol {
   
    
    var choiseChart: GraphInfo!
    var delegate = AppDelegate()
    
    let choiseGraph: Int = 0
    
    var widthGraph: Double = 0
    let heightGraphView: CGFloat = 200
    let heightDateView: CGFloat = 30
    let minCountDay: Int = 30
    var isSetHeight: Bool = true
    var arrHidden: [String] = []
    var isLoad: Int = 0
    var isDay: Bool = true
    
//    @IBOutlet weak var titleLabelNavigationBar: UILabel!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var dateView: DateView!
    var graphView: GraphView!
    @IBOutlet weak var graphViewSmall: GraphView!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonTheme: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBAction func tapButtonTheme(_ sender: UIButton) {
        setTheme(isDay: self.isDay)
        self.isDay = !self.isDay
    }
    
    
    @IBAction func RangeSliderOutSide(_ sender: RangeSlider) {
        self.dateView.clearLabelsAplpha()
    }
    @IBAction func RangeSliderValueChanged(_ sender: RangeSlider) {
        
        if !sender.centerThumbLayer.highlighted{
            setSizeGraph(width: Double(self.scrollView.frame.width) * Double(1.0 / (sender.upperValue - sender.lowerValue)))
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
        let heightCell = self.tableView.rowHeight
        self.heightTableViewConstraint.constant = heightCell * CGFloat(self.choiseChart.arrLineName.count)
        createViewInContentView()
        initDefault()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isLoad = isLoad + 1
        if isLoad == 2{
            setGraph()
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func createViewInContentView(){
        self.scrollView.backgroundColor = UIColor.white
        self.graphView = GraphView(frame: CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height - self.heightDateView))
        self.scrollView.addSubview(self.graphView)
        self.dateView = DateView(frame: CGRect(x: 0, y: self.graphView.frame.height, width: self.graphView.frame.width, height: self.heightDateView))
        self.scrollView.addSubview(self.dateView)
    }
    
    private func initDefault(){
        self.rangeSlider.frame.size = CGSize(width: self.view.frame.width, height: self.rangeSlider.frame.height)
        self.followersLabel.alpha = 0.8
    }
    
    func setSizeGraph(width: Double){
        self.graphView.setWidth(width: width, height: Double(self.scrollView.frame.height - self.heightDateView), contentOfSet: self.scrollView.contentOffset.x, viewWidth: self.scrollView.frame.width)
        self.scrollView.contentSize = CGSize(width: CGFloat(width), height: self.scrollView.frame.height)
        self.dateView.setWidth(x: 0, y: self.scrollView.frame.height - self.heightDateView, width: CGFloat(width), height: self.heightDateView)
        
    }
    
    func setGraph(){
        self.widthGraph = Double(self.scrollView.frame.width) / Double(self.minCountDay) * Double(self.choiseChart.arrDayInfo.count - 1)
        
        setSizeGraph(width: self.widthGraph)
        
        let contentOffSet: CGFloat = CGFloat(self.widthGraph) - self.scrollView.frame.width
        self.graphView.setPoints(graph: self.choiseChart, verticalGrid: true, contentOffSet: contentOffSet, width: self.scrollView.frame.width)
        self.graphViewSmall.setPoints(graph: self.choiseChart, isFullscreen: false, width: self.graphViewSmall.frame.width)
        self.scrollView.setContentOffset(CGPoint(x: contentOffSet, y: 0), animated: false)
        self.rangeSlider.setPointsValue(lower: 1.0 - self.scrollView.frame.width / CGFloat(self.widthGraph), upper: 1.0)
        self.dateView.setDate(data: self.choiseChart)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentIndex = scrollView.contentOffset.x
        if contentIndex < 0{
            self.scrollView.contentOffset.x = 0
        }
        if contentIndex > self.scrollView.contentSize.width - self.scrollView.frame.width{
            self.scrollView.contentOffset.x = self.scrollView.contentSize.width - self.scrollView.frame.width
        }
    }
    
    // Table View
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choiseChart.arrLineName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chCell", for: indexPath)
        cell.accessoryType = .checkmark
        cell.textLabel?.text = self.choiseChart.arrLineName[indexPath.row]
        let theme = ThemeColors()
        let backView = UIView()
        if !self.isDay{
            cell.textLabel?.textColor = theme.tintColorNight
            backView.backgroundColor = theme.backColorNight
            cell.backgroundColor = theme.frontColorNight
        }
        else{
            cell.textLabel?.textColor = theme.tintColorDay
            backView.backgroundColor = theme.backtColorDay
            cell.backgroundColor = theme.frontColorDay
        }
        cell.selectedBackgroundView = backView
        let viewToImage = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        viewToImage.backgroundColor = self.choiseChart.arrLineColor[indexPath.row]
        viewToImage.layer.cornerRadius = viewToImage.frame.height / 2
        let image: UIImage = UIImage(view: viewToImage)
        cell.imageView?.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            self.arrHidden.append(name)
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.arrHidden.remove(at:self.arrHidden.firstIndex(of: name)!)
            
        }
        self.graphView.setGraphHidden(names: self.arrHidden)
        self.graphView.scaleVerticalGraph(contentOfSet: self.scrollView.contentOffset.x, viewWidth: self.scrollView.frame.width, isSetHeightOnly: true)
        self.graphViewSmall.setGraphHidden(names: self.arrHidden)
        self.graphViewSmall.scaleVerticalGraph(contentOfSet: 0, viewWidth: self.graphViewSmall.frame.width, isSetHeightOnly: true)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    private func setTheme(isDay: Bool){
        let theme = ThemeColors()
        let frontColor: UIColor!
        let backColor: UIColor!
        let barStyle: UIBarStyle!
        let separatorColor: UIColor!
        let textButton: String!
        let textColor: UIColor!
        
        if !isDay{
            frontColor = theme.frontColorDay
            backColor = theme.backtColorDay
            barStyle = UIBarStyle.default
            separatorColor = theme.backtColorDay
            textButton = "Switch to Day Mode"
            textColor = theme.tintColorDay
        }
        else{
            frontColor = theme.frontColorNight
            backColor = theme.backColorNight
            barStyle = UIBarStyle.black
            separatorColor = theme.backColorNight
            textButton = "Switch to Night Mode"
            textColor = theme.tintColorNight
        }
        
        UIView.animate(withDuration: theme.duration) {
            self.view.backgroundColor = backColor
            
            self.tableView.backgroundColor = frontColor
            self.contentView.backgroundColor = frontColor
            self.scrollView.backgroundColor = frontColor
            
            self.buttonTheme.backgroundColor = frontColor
            self.navigationController?.navigationBar.barTintColor = frontColor
            self.navigationController?.navigationBar.barStyle = barStyle
        }
        self.tableView.reloadData()
        self.tableView.separatorColor = separatorColor
        
        self.buttonTheme.setTitle(textButton, for: .normal)
        
        self.dateView?.setTheme(isDay: isDay)
        self.graphView?.setTheme(isDay: isDay)
        self.graphViewSmall?.setTheme(isDay: isDay)
        
    }
    
}
