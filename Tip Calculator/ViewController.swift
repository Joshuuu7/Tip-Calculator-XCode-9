//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Joshua Aaron Flores Stavedahl on 10/5/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

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
    var decimalCount = 1
    var decimalChar = "."
    var dollarChar = "$"
    let totalPercentage : Float = 100
    var billAmountStringArray = [String]()
    var reversedBillAmountStringArray = [String]()
    var billAmountString = ""
    var tipSliderMoved = false
    var partySliderMoved = false
    var currentString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //textField.delegate = self
        billAmountTextField.keyboardType = .decimalPad
        
        billAmountTextField.delegate = self as? UITextFieldDelegate
        configureBillAmountTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func billAmountTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func errorSoundVibrate() {
        let systemSoundID: SystemSoundID = 1053
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    func showAlertWithoutButton(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func configureBillAmountTextField() {
        
        changeTipAmount(tipSlider)
        changePartyCount(partySizeSlider)
        //textField( _: billAmountTextField, shouldChangeCharactersIn: NSRange(), replacementString: billAmountString)
        //billAmount = Float(billAmountTextField.text!)!
        
        for _ in [billAmount]
        {
            billAmountStringArray = billAmountStringArray.reversed()
            billAmountStringArray.append("\(billAmount)")
            //billAmountStringArray = billAmountStringArray.reversed()
        }
        print(billAmountStringArray)
        //billAmountString = billAmountStringArray as! String
        //billAmountTextField.text! = "\(billAmountStringArray)"
    }
    
    @IBAction func changeTipAmount(_ sender: UISlider) {
        tipSliderMoved = true
        let tipInterval: Float = 5                                                    // Creates a constant for tip intervals of 5
        let percentage = round( sender.value / tipInterval ) * tipInterval     // Creates intervals of five
        sender.value = percentage                                             // Update the slider's value
        self.tipPercentage.text = "\(Int(percentage))%"                       // Displays the label as an integer percentage
        //billAmount = Float((billAmountTextField.text!))!
        
        if (billAmountTextField.text?.isEmpty)! {
            //billAmountString = "$" + "\(billAmountTextField.text!)"
            //billAmountTextField.text = billAmountString
            self.tipAmount.text = "$\(billAmount)0"                            // Displays the label as an integer percentage
            
        }
            
            /*
             else if ( billAmountTextField.text
             */
            
        else {
            //billAmountString = "$" + "\(billAmountTextField.text!)"
            //billAmountTextField.text = billAmountString
          
            if Float(billAmountTextField.text!) != nil  {
                correctInputTextField(textField: billAmountTextField)
                billAmount = Float(billAmountTextField.text!)!
                let tipDollarAmountHolder = billAmount * percentage / totalPercentage + billAmount
                
                let tipAmountDollarAsCurrency = String( tipDollarAmountHolder )
                
                let tipDollarCurrency = cleanDollars(tipAmountDollarAsCurrency)
                
                self.tipAmount.text = "\(tipDollarCurrency)"
                
                
            } else {
                
                self.errorSoundVibrate()
                self.showAlertWithoutButton(title: "ERROR!", message: "\n Enter a number with one decimal only.")
                erroFocusOnTextField(textField: billAmountTextField)
            }
        }
    }
    
    func erroFocusOnTextField( textField: UITextField ) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 2.0
        textField.text = ""
    }
    
    func correctInputTextField( textField: UITextField ) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    
    @IBAction func changePartyCount(_ sender: UISlider) {
        partySliderMoved = true
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
            
            let tipAmount = billAmount * Float(percentage) / totalPercentage + billAmount
            let tipPerPerson = tipAmount / Float(partySize)
            
            let tipDollarsPerPerson = String( tipPerPerson )
            
            let tipDollarAsCurrencyPerPerson = cleanDollars( tipDollarsPerPerson )
            
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
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: floatValue)) ?? "$\(floatValue)"
    }
    
    func convertTextField( input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func convertDoubleToCurrency(amount: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func calculateAllTips() {
        
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = billAmountTextField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }*/
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let decimalPlacesLimit = 2
        let rangeDot = billAmountTextField.text!.range(of: ".", options: .caseInsensitive)
        
        billAmountTextField.keyboardType = .decimalPad
        billAmountTextField.textAlignment = .center
        billAmountTextField.placeholder = "$0.00"
        if billAmountTextField.text == nil{
            billAmountTextField.text = "0.00"
        }
        if tipSliderMoved == true || partySliderMoved == true {
            
            if rangeDot?.count != nil
            {
                if (string == ".")
                {
                    print("textField already contains a separator")
                    return false
                }
                else {
                    
                    var explodedString = billAmountTextField.text!.split(separator: ".")
                    let decimalPart = explodedString[1]
                    if decimalPart.characters.count >= decimalPlacesLimit && !(string == "")
                    {
                        print("textField already contains \(decimalPlacesLimit) decimal places")
                        return false
                    }
                }
            }
            
            billAmountStringArray = [billAmountTextField.text] as! [String]
            reversedBillAmountStringArray = billAmountStringArray.reversed()
            billAmountTextField.text! = reversedBillAmountStringArray.joined(separator: "")
            
            var dotString = "."
            
            /*if ( dotString.count >= 2 ) {
             dotString.remove(at: billAmountTextField.text!)
             }*/
            
            if let text = billAmountTextField.text {
                let isDeleteKey = string.isEmpty
                
                if !isDeleteKey {
                    if text.contains(dotString) {
                        if text.components(separatedBy: dotString)[1].count >= 2 {
                            
                            return false
                        }
                    }
                }
            }
        }
        return true
    }*/
    
    func hideKeyboard() {
        billAmountTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        changeTipAmount(tipSlider)
        changePartyCount(partySizeSlider)
        return true
    }

}

