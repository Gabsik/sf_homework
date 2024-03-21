//
//  ViewController.swift
//  calculator
//
//  Created by User on 19.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var numberFromScreen: Double = 0
    var firstNumber: Double = 0
    var mathSign: Bool = false
    var operation: Int = 0
    
    @IBAction func numbersButton(_ sender: UIButton) {
        
        if mathSign == true {
            resultLabel.text = String(sender.tag)
            mathSign = false
        }
        else {
            resultLabel.text = resultLabel.text! + String(sender.tag)

        }
        numberFromScreen = Double(resultLabel.text!)!
    }
    @IBAction func actionsButton(_ sender: UIButton) {
        if resultLabel.text != "" && sender.tag != 10 && sender.tag != 15  {
            firstNumber = Double(resultLabel.text!)!
            if sender.tag == 11 { // Деление
                resultLabel.text = "/"
            }
            else if sender.tag == 12 { // умнажение
                resultLabel.text = "x"
            }
            else if sender.tag == 13 { // вычетание
                resultLabel.text = "-"
            }
            else if sender.tag == 14 { // сложение
                resultLabel.text = "+"
            }
            mathSign = true
            operation = sender.tag
        }
        else if sender.tag == 15 { //равно
            if operation == 11 {
                resultLabel.text = String(firstNumber / numberFromScreen)
            }
            else if operation == 12 {
                resultLabel.text = String(firstNumber * numberFromScreen)
            }
            else if operation == 13 {
                resultLabel.text = String(firstNumber - numberFromScreen)
            }
            else if operation == 14 {
                resultLabel.text = String(firstNumber + numberFromScreen)
            }
        }
        else if sender.tag == 10 {
            resultLabel.text = ""
            firstNumber = 0
            numberFromScreen = 0
            operation = 0
        }
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
