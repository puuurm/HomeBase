//
//  SquadEditPlayerViewController.swift
//  HomeBase
//
//  Created by JUN LEE on 2017. 8. 17..
//  Copyright © 2017년 LemonKooma. All rights reserved.
//

import UIKit

class SquadEditPlayerViewController: UIViewController, CustomAlertShowing {
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: Properties
    
    var player: Player!
    
    @IBOutlet var playerNameTextField: UITextField!
    @IBOutlet var backNumberTextField: UITextField!
    @IBOutlet var positionPickerView: UIPickerView!
    
    var kindOfPosition: [String] = {
        var array = ["SP", "RP", "CP", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH"]
        
        return array
    }()
    
    var positionNumber: Int = 0
    
    // MAKR: Actions
    
    @IBAction func clickCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickDoneButton(_ sender: UIBarButtonItem) {
        if playerNameTextField.text == "" {
            showAlertOneButton(
                title: .alertActionTitle,
                message: .alertMessageOfEnterPlayerName)
        } else if backNumberTextField.text == "" {
            showAlertOneButton(
                title: .alertActionTitle,
                message: .alertMessageOfEnterPlayerBackNumber)
        } else {
            showAlertTwoButton(
                title: .alertTitleOfEditPlayer,
                message: .alertMessageOfEditPlayer,
                cancelActionTitle: .cancelActionTitle,
                confirmActionTitle: .confirmActionTitle,
                confirmAction: editPlayer)
        }
    }
    
    fileprivate func editPlayer(action: UIAlertAction) {
        if let updatedName = playerNameTextField.text,
            let updatedBackNumberString = backNumberTextField.text {
            
            let updatedPosition = kindOfPosition[positionPickerView.selectedRow(inComponent: 0)]
            
            let updatePlayer = Player(
                id: player.playerID,
                name: updatedName,
                backNumber: Int(updatedBackNumberString)!,
                position: updatedPosition)
            
            do {
                try PlayerDAO.shared.update(item: updatePlayer)
                dismiss(animated: true, completion: nil)
            } catch let error {
                print(error)
                showAlertOneButton(
                    title: .alertActionTitle,
                    message: .alertMessageOfDuplicatePlayerBackNumber)
                
            }
        }
    }
    
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        playerNameTextField.text = player.name
        backNumberTextField.text = String(player.backNumber)
        
        positionPickerView.dataSource = self
        positionPickerView.delegate = self
        
        backNumberTextField.delegate = self
        for index in 0..<kindOfPosition.count {
            if player.position == "\(kindOfPosition[index])" {
                positionNumber = index
                break
            }
        }
        positionPickerView.showsSelectionIndicator = true
        positionPickerView.selectRow(positionNumber, inComponent: 0, animated: false)
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = kindOfPosition[row]
        pickerLabel.textAlignment = .center
        
        return pickerLabel
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
            showAlertOneButton(
                title: .alertActionTitle,
                message: .alertMessageOfMaxPlayerBackNumber)
            
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
}
