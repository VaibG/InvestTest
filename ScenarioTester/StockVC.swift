//
//  StockVC.swift
//  ScenarioTester
//
//  Created by Vaibhav Gattani on 2/11/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class StockVC: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tickerView: UITableView!
    @IBOutlet weak var enterTicker: UITextField!
    @IBOutlet weak var enterPercentage: UITextField!
    @IBOutlet weak var nameOfPortfolio: UITextField!
    
    var timePeriods = ["Recovery After Dotcom Crash", "2008 Recession", "Recovery after 2008"]
    var allTickers: [String] = []
    var allWeight: [String] = []
    var dates_dict = ["Recovery After Dotcom Crash": ["20020131", "20061130"], "2008 Recession": ["20061130", "20090331"], "Recovery after 2008": ["20090331", "20180930"]]
    var sendPortfolio: Stock!
    var sendScenario: String!
    var sendName: String!
    var sendStartDate: String!
    var sendEndDate: String!
    var sendPortPath: String!
    var inputName: SkyFloatingLabelTextField!
    var inputTicker: SkyFloatingLabelTextField!
    var inputPercent: SkyFloatingLabelTextField!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        pickerView.dataSource = self
        pickerView.delegate = self
        createTableView()
        
        self.navigationItem.title = "InvestTest"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.submitTapped))
        
        
        // Do any additional setup after loading the view.
    }
    
    func createUI() {
        inputName = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 40))
        inputName.placeholder = "Portfolio Name"
        inputName.title = "Portfolio Name"
        inputName.font = UIFont(name: "AvenirNext-Bold", size: 20)
        inputName.selectedTitleColor = .white
        inputName.selectedLineColor = .white
        inputName.textColor = .white
        inputName.textAlignment = .center
        inputName.center = CGPoint(x: view.frame.width/2, y: 100)
        view.addSubview(inputName)
        
        
        inputTicker = SkyFloatingLabelTextField(frame: enterTicker.frame)
        inputTicker.placeholder = "Ticker"
        inputTicker.title = "Ticker"
        inputTicker.font = UIFont(name: "AvenirNext-Bold", size: 18)
        inputTicker.selectedTitleColor = .white
        inputTicker.selectedLineColor = .white
        inputTicker.textColor = .white
        inputTicker.textAlignment = .center
        view.addSubview(inputTicker)
        
        inputPercent = SkyFloatingLabelTextField(frame: enterPercentage.frame)
        inputPercent.placeholder = "% of Portfolio"
        inputPercent.title = "Percentage"
        inputPercent.font = UIFont(name: "AvenirNext-Bold", size: 18)
        inputPercent.selectedTitleColor = .white
        inputPercent.selectedLineColor = .white
        inputPercent.textColor = .white
        inputPercent.textAlignment = .center
        view.addSubview(inputPercent)
        
        
        
    }
    
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
    
        if allTickers.contains(inputTicker.text!) {
            displayAlert(title: "Invalid Ticker", message: "This ticker has already been added to the portfolio")
            return
        }
        allTickers.append(inputTicker.text!)
        allWeight.append(inputPercent.text!)

        inputTicker.text = ""
        inputPercent.text = ""
    
        tickerView.reloadData()
    
    }
    
    @objc func submitTapped() {
        
        let x = parsePortfolio()
        if inputName.text == ""{
            displayAlert(title: "No Name", message: "Please enter a name for your Portfolio")
        } else {
            sendName = inputName.text
        
        }
        let y = pickerView.selectedRow(inComponent: 0)
        sendScenario = timePeriods[y]
        sendStartDate = dates_dict[sendScenario]![0]
        sendEndDate = dates_dict[sendScenario]![1]
        sendPortPath = x
        BlackRockAPIHelper.getStock(view: self, portfolio: x, startDate: dates_dict[timePeriods[y]]![0], endDate: dates_dict[timePeriods[y]]![1]) { stock in
            self.sendPortfolio = stock
            self.performSegue(withIdentifier: "toPortfolioInfo", sender: nil)
        }

    }
    
    func parsePortfolio() -> String {
        var portfolioInput: String = ""
        for x in 0..<allTickers.count {
            portfolioInput = portfolioInput + allTickers[x] + "~" + allWeight[x] + "&7C"
        }
        return portfolioInput
    }
    
    func createTableView() {
        tickerView.delegate = self
        tickerView.dataSource = self
        tickerView.register(TickerTableViewCell.self, forCellReuseIdentifier: "ticker")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PortfolioInfoVC {
            destination.startDate = sendStartDate
            destination.endDate = sendEndDate
            destination.PortPath = sendPortPath
            destination.portfolio = sendPortfolio
            destination.name = sendName
            destination.scenario = sendScenario
            destination.tickerBreakdown = allTickers
            destination.weightBreakdown = allWeight
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

extension StockVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePeriods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = timePeriods[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

}

extension StockVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tickerView.dequeueReusableCell(withIdentifier: "ticker", for: indexPath) as! TickerTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.tickerLabel.text = allTickers[indexPath.row]
        cell.percentageLabel.text = allWeight[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allTickers.remove(at: indexPath.row)
            allWeight.remove(at: indexPath.row)
            tickerView.deleteRows(at: [indexPath], with: .automatic)
        
        }
        
    }
    
    
    
    
}
