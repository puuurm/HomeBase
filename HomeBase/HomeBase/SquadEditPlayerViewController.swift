//
//  SquadEditPlayerViewController.swift
//  HomeBase
//
//  Created by JUN LEE on 2017. 8. 17..
//  Copyright © 2017년 LemonKooma. All rights reserved.
//

import UIKit

class SquadEditPlayerViewController: UIViewController {
    
    // MARK: Properties
    
    var playerName: String!
    var backNumber: Int64!
    var position: String!
    
    @IBOutlet var playerNameTextField: UITextField!
    @IBOutlet var backNumberTextField: UITextField!
    @IBOutlet var positionPickerView: UIPickerView!
    
    var kindOfPosition: [String] = {
        var array = ["SP", "RP", "CP", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH"]
        
        return array
    }()
    
    // MAKR: Actions
    
    @IBAction func clickCancelButton(_ sender: UIBarButtonItem) {
    }
    @IBAction func clickDoneButton(_ sender: UIBarButtonItem) {
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTextField.text = playerName
        backNumberTextField.text = String(backNumber)
        
        var positionNumber: Int = 0
        for index in 0..<kindOfPosition.count {
            if position == "\(kindOfPosition[index])" {
                positionNumber = index
            }
        }
        positionPickerView.selectRow(positionNumber, inComponent: 0, animated: false)
        
        positionPickerView.dataSource = self
        positionPickerView.delegate = self
        
        backNumberTextField.delegate = self
    }
}

// MARK: PickerDelegate

extension SquadEditPlayerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kindOfPosition.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kindOfPosition[row]
    }
}


// MARK: TextFieldDelegate

extension SquadEditPlayerViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCount = textField.text?.characters.count ?? 0
        let replacementCount = currentCount + string.characters.count - range.length
        
        if replacementCount <= 2 {
            return true
        }
        else {
            let alertController = UIAlertController(title: "", message: "선수 번호는 최대 99 입니다",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
}