//
//  graphVC.swift
//  ScenarioTester
//
//  Created by Vaibhav Gattani on 3/11/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit
import Charts

class graphVC: UIViewController {

    @IBOutlet weak var linearChart: LineChartView!
    
    var portfolio: Stock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLineGraph()
        // Do any additional setup after loading the view.
    }
    
    func createLineGraph() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<portfolio.points.count {
            let test = NumberFormatter().number(from: portfolio.points[i].level!)
            
            let value = ChartDataEntry(x: Double(i), y: test as! Double)
            lineChartEntry.append(value)
        }
        
        let xAxis = linearChart.xAxis
        xAxis.labelTextColor = UIColor.white
        
        let yAxis = linearChart.leftAxis
        yAxis.labelTextColor = .white
        
        linearChart.chartDescription?.enabled = false
        linearChart.dragEnabled = true
        linearChart.setScaleEnabled(true)
        linearChart.pinchZoomEnabled = true
        linearChart.rightAxis.enabled = false

        let line1 = LineChartDataSet(values: lineChartEntry, label: "Portfolio")
        line1.colors = [UIColor.white]
        line1.circleRadius = 0
        
        
        let marker: BalloonMarker = BalloonMarker(color: UIColor.black, font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0))
        marker.minimumSize = CGSize(width: 75.0, height: 35.0)
        linearChart.marker = marker
        
        let data = LineChartData()
        data.addDataSet(line1)
        linearChart.data = data

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
