//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Joshua Aaron Flores Stavedahl on 10/5/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIApplicationDelegate {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentage: UILabel!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var partySizeSlider: UISlider!
    @IBOutlet weak var partyCount: UILabel!
    @IBOutlet weak var partyAmount: UILabel!
    
    var billAmount : Float = 0.00
    var percentage = 20
    var partySize = 1
    let totalPercentage : Float = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeTipAmount(_ sender: UISlider) {
        let tipInterval: Float = 5                                                    // Creates a constant for tip intervals of 5
        let percentage = round( sender.value / tipInterval ) * tipInterval     // Creates intervals of five
        sender.value = percentage                                             // Update the slider's value
        self.tipPercentage.text = "\(Int(percentage))%"                       // Displays the label as an integer percentage
        //billAmount = Float((billAmountTextField.text!))!
            
            if (billAmountTextField.text?.isEmpty)! {
                
                self.tipAmount.text = "$\(billAmount)0"                            // Displays the label as an integer percentage
                
            }
            else{
                billAmount = Float(billAmountTextField.text!)!
                let tipDollarAmountHolder = billAmount * percentage / totalPercentage + billAmount
                
                let tipAmountDollarAsCurrency = String( tipDollarAmountHolder )
                
                let tipDollarCurrency = cleanDollars(tipAmountDollarAsCurrency)
                
                self.tipAmount.text = "\(tipDollarCurrency)"                            // Displays the label as an integer percentage
            }
        
    }
    
    
    @IBAction func changePartyCount(_ sender: UISlider) {
        self.view.endEditing(true)
        let partyCountInterval: Float = 1              // Constant for intended for intervals of "1" in partyCount label
        let partyCountValue = round( sender.value / partyCountInterval ) * partyCountInterval  // Constant initialized with the Float value returned from the operation within that gets the value from the Slider, then divides it by 1 and then multiplies that result by 1
        
        sender.value = partyCountValue                  // Initializes the value on the slider to the value in "partyCountValue"
        partySize = Int(partyCountValue)
        partyCount.text = "\(partySize)"     // Displays the value on the partyCount label with the appropriate intervals
        if ( billAmountTextField.text == nil ) {
            
            
            self.partyAmount.text = "$0.00"                            // Displays the label as an integer percentage
            
        }
        else{
            
            let tipAmount = billAmount * Float(percentage) /  totalPercentage + billAmount 
            let tipPerPerson = tipAmount/Float(partySize)
            
            let tipDollarsPerPerson = String( tipPerPerson )
            
            let tipDollarAsCurrencyPerPerson = cleanDollars(tipDollarsPerPerson)
            
            self.partyAmount.text = "\(tipDollarAsCurrencyPerPerson)"                          // Displays the label as an integer percentage
        }
        //let partyAmountCalculated = tipDollarCurrency + String ( billAmount )
        //partyAmount.text = "\(Float(tipDollarCurrency)"
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func cleanDollars(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let floatValue = Float(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: floatValue)) ?? "$\(floatValue)"
    }

}

