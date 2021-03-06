//
//  ConversionViewController.swift
//  WorldTrotter-V2
//
//  Created by Alexis Kirkman on 1/26/17.
//  Copyright © 2017 Alexis Kirkman. All rights reserved.
//

import UIKit

let numberFormatter: NumberFormatter = {
   let nf = NumberFormatter()
   nf.numberStyle = .decimal
   nf.minimumFractionDigits = 0
   nf.maximumFractionDigits = 1
   return nf
}()


class ConversionViewController: UIViewController, UITextFieldDelegate{
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("ConversionViewController loaded its view.")

      updateCelsiusLabel()
   }

   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      let currentLocale = Locale.current
      let decimalSeparator = currentLocale.decimalSeparator ?? "."
      let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
      let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
      

      
      //Restricts user from entering multiple decimal points
      if existingTextHasDecimalSeparator != nil,
         replacementTextHasDecimalSeparator != nil {
         return false
      }
      
      //User hasn't entered text returns true
      if string.characters.isEmpty {
         return true
      }
      //Disallows user from entering non-numeric characters
      if string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "-0123456789.,").inverted as CharacterSet) != nil{
         return false
      }
      
      return true
   }

   
   @IBOutlet var celsiusLabel: UILabel!
   var fahrenheitValue: Measurement < UnitTemperature >?{
      didSet {
         updateCelsiusLabel()
      }
      
   }
   
   var celsiusValue: Measurement < UnitTemperature >? {
      if let fahrenheitValue = fahrenheitValue {
         return fahrenheitValue.converted( to: .celsius)
      } else {
         return nil
      }
   }
   
   func updateCelsiusLabel() {
      if let celsiusValue = celsiusValue {
         celsiusLabel.text =
            numberFormatter.string( from: NSNumber( value: celsiusValue.value))
      } else {
         celsiusLabel.text = "???"
      }
   }
   
   @IBOutlet var textField: UITextField!
   
   @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
      if let text = textField.text, let number = numberFormatter.number(from: text) {
         fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
      } else {
         fahrenheitValue = nil
      }
      
     
   }
   
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
      textField.resignFirstResponder()
   }
   
   //Silver Challenge: Dark Mode
   override func viewWillAppear(_ animated: Bool) {
      var hour: Int?
      let currentDate = NSDate()
      let dateFormatter = DateFormatter()
      dateFormatter.locale = NSLocale.current
      dateFormatter.dateFormat = "HH"
      hour = Int(dateFormatter.string(from: currentDate as Date))
      if hour! < 7 || hour! > 19 {
         view.backgroundColor = UIColor.gray
      } else {
         view.backgroundColor = UIColor.cyan
      }
   }
   
   
}
