//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Paul Baker on 1/31/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit


// Updates the celsius label when app opens
class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad(){
        
        darkenMode()
        super.viewDidLoad()
        
        
        print("ConversionViewController loaded it's view")
        
        updateCelsiusLabel()
    }
    
    func darkenMode()
    {
        let darkColor = UIColor(red: 51/255, green: 52/255, blue: 50/255, alpha: 1.0)
        let greyColor = UIColor(red: 238/255, green: 240/255, blue: 239/255, alpha: 1.0)
        let darkHour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        
        switch darkHour {
        case 1...25:
            view.backgroundColor = darkColor
        case 26...48:
            view.backgroundColor = greyColor
        case 49...60:
            view.backgroundColor = darkColor
        default:
            break
        }
    }
    
    // Checks if there is already a decimal and prevents additional decimal points
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let temp = fahrenheitValue?.value
        if let t = temp, t < 25.0 {
            let alert = UIAlertController(title: "Brrr!", message: "\(t)F is cold", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // This is the outlet for the celsius label
    @IBOutlet var celsiusLabel: UILabel!
    // checks if the value of fahrenheit changed
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    // This converts fahrenheit to celsius and if there is no temp returns nil
    var celsiusValue: Measurement<UnitTemperature>? {
    if let fahrenheitValue = fahrenheitValue {
        return fahrenheitValue.converted(to: .celsius)
    } else {
    return nil
    }
    }
    // Formats the numbers so there is only one deicmal place
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    // Updates the celsius label
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    
    
    @IBOutlet var textField: UITextField!
    
    // Closes the keyboard if there is a click on the background field
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
        
        
    }

}
