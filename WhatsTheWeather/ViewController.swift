//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Vu Tran on 6/11/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityField: UITextField!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeparator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            stringSeparator = "</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 0 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                DispatchQueue.main.sync {
                                    self.resultLabel.textColor = UIColor.green
                                }
                                print(message)
                            }
                            
                        }
                    }
                }
            }
            if message == "" {
                message = "The weather there couldn't be found. Please try again."
                DispatchQueue.main.sync {
                    self.resultLabel.textColor = UIColor.red
                }
            }
            DispatchQueue.main.sync(execute: {
                
                self.resultLabel.text = message
            })
        }
        task.resume()
        
        } else {
//            resultLabel.textColor = UIColor.red
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

