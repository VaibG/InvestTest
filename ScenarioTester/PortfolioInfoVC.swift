//
//  PortfolioInfoVC.swift
//  ScenarioTester
//
//  Created by Vaibhav Gattani on 3/11/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit
import Charts

class PortfolioInfoVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var viewGraph: UIButton!
    @IBOutlet weak var helpButtonOne: UIButton!
    @IBOutlet weak var helpButtonTwo: UIButton!
    
    var portfolio: Stock!
    var name: String!
    var scenario: String!
    var tickerBreakdown: [String]!
    var weightBreakdown: [String]!
    var startDate: String!
    var endDate: String!
    var PortPath: String!
    var marketPerfomance: [Float] = [34.53920081, -39.99716356, 343.1111009]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewGraph.isHidden = true
        getGraph()
        createPieChart()
        createTableView()
        setCurrent()
        titleLabel.text = "PORTFOLIO BREAKDOWN DURING " + scenario
        helpButtonOne.addTarget(self, action: #selector(helpBestClicked), for: .touchUpInside)
        helpButtonTwo.addTarget(self, action: #selector(helpClicked), for: .touchUpInside)
        
        self.navigationItem.title = name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addToLeaderBoard))
        // Do any additional setup after loading the view.
    }
    
    
    func setCurrent() {
        helpButtonOne.layer.cornerRadius = 0.5*helpButtonOne.bounds.size.width
        helpButtonTwo.layer.cornerRadius = 0.5*helpButtonTwo.bounds.size.width
        
        var x: Float = 0.0
        if scenario == "Recovery After Dotcom Crash" {
            x = portfolio.performance! - marketPerfomance[0]
        } else if scenario == "2008 Recession" {
            x = portfolio.performance! - marketPerfomance[1]
        } else if scenario == "Recovery after 2008" {
            x = portfolio.performance! - marketPerfomance[2]
        }
        currentScore.text = x.description
        let current = x
        let defaults = UserDefaults.standard
        if defaults.float(forKey: scenario) == nil {  //date is the period the payer is in e.x. "recession"
            defaults.set(current, forKey: scenario)
        }
        else if current > defaults.float(forKey: scenario){
            defaults.set(current, forKey: scenario)
        }
        bestScore.text = defaults.float(forKey: scenario).description
    }
    
    func createTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: "ticker")
    }
    
    func createPieChart() {
        pieChart.chartDescription?.enabled = false
        pieChart.rotationEnabled = false
        pieChart.rotationAngle = 0
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.3
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.holeColor = UIColor.clear

        
        var entries: [PieChartDataEntry] = []
        for i in 0..<weightBreakdown.count {
            entries.append(PieChartDataEntry(value: Double(weightBreakdown![i])!, label: tickerBreakdown![i]))
        }
        let dataSet = PieChartDataSet(values: entries, label: "")
        dataSet.colors = [UIColor(red:0.16, green:0.66, blue:0.19, alpha:1.0), UIColor.gray, UIColor(red:0.42, green:0.27, blue:0.67, alpha:1.0), UIColor.black, UIColor(red:0.58, green:0.14, blue:0.14, alpha:1.0), UIColor.darkGray]

        
        pieChart.data = PieChartData(dataSet: dataSet)
        
        }
    
    func getGraph() {
        BlackRockAPIHelper.getGraph(view: self, completeAll: portfolio, portfolio: PortPath, startDate: startDate, endDate: endDate) {stk in
            self.portfolio = stk
            self.viewGraph.isHidden = false
        }
    }
    
    
    @IBAction func segueGraph(_ sender: Any) {
        
        performSegue(withIdentifier: "viewGraph", sender: nil)
    }
    
    
    @objc func addToLeaderBoard() {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? graphVC {
            destination.portfolio = portfolio
            
        }
        
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

extension PortfolioInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickerBreakdown.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticker", for: indexPath) as! TickerTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.tickerLabel.text = tickerBreakdown[indexPath.row]
        cell.percentageLabel.text = weightBreakdown[indexPath.row]
        return cell
    }
    
    @objc func helpClicked() {
        displayAlert(title: "Current Score", message: "The Current Score is equal to the total returns of the Portfolio subtracted by the total returns of the S&P 500 Index")
    }
    
    @objc func helpBestClicked() {
        displayAlert(title: "Best Score", message: "The Best Score displays the best return of one of the user's portfolio. The score is calculated by the total returns of the Portfolio subtracted by the total returns of the S&P 500 Index")
    }

    
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

