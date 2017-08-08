//
//  TeamImageViewController.swift
//  HomeBase
//
//  Created by JUN LEE on 2017. 8. 7..
//  Copyright © 2017년 LemonKooma. All rights reserved.
//

import UIKit

class TeamImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    
    fileprivate lazy var pickerButton: UIButton = {
        let pickerButton = UIButton(type: .system)
        pickerButton.setTitle("팀 대표 이미지를 등록하세요", for: .normal)
        pickerButton.titleLabel?.font = UIFont(name: "System", size: 22.0)
        pickerButton.titleLabel?.textAlignment = .center
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        pickerButton.addTarget(self, action: #selector(clickPickerButton(_:)), for: .touchUpInside)
        
        return pickerButton
    }()
    
    fileprivate lazy var skipButton: UIButton = {
        let skipButton = UIButton(type: .system)
        skipButton.setTitle("skip", for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "System", size: 20.0)
        skipButton.titleLabel?.textAlignment = .center
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        return skipButton
    }()
    
    fileprivate lazy var teamImage: UIImageView = {
        let teamImage = UIImageView()
        teamImage.translatesAutoresizingMaskIntoConstraints = false
        
        return teamImage
    }()
    
    fileprivate lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("done", for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "System", size: 20.0)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return doneButton
    }()
    
    // MARK: Actions
    
    @objc func clickPickerButton(_ sender: AnyObject) {
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        
        self.pickerButton.removeFromSuperview()
        self.skipButton.removeFromSuperview()
        
        self.view.addSubview(teamImage)
        self.view.addConstraints(teamImageConstraint())
        self.view.addSubview(doneButton)
        self.view.addConstraints(doneButtonConstraint())
        
        self.teamImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pickerButton)
        self.view.addSubview(skipButton)
        
        self.view.addConstraints(pickerButtonConstraints())
        self.view.addConstraints(skipButtonConstraints())
    }
}

// MARK: Layout Constraints

extension TeamImageViewController {
    
    fileprivate func pickerButtonConstraints() -> [NSLayoutConstraint] {
        let centerXConstraint = NSLayoutConstraint(item: pickerButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: pickerButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.9, constant: 0.0)
        
        return [centerXConstraint, centerYConstraint]
    }
    
    fileprivate func skipButtonConstraints() -> [NSLayoutConstraint] {
        let centerXConstraint = NSLayoutConstraint(item: skipButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: skipButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.1, constant: 0.0)
        
        return [centerXConstraint, centerYConstraint]
    }
    
    fileprivate func teamImageConstraint() -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: teamImage, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.3, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: teamImage, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: teamImage, attribute: .width, relatedBy: .equal, toItem: teamImage, attribute: .height, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: teamImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        return [topConstraint, bottomConstraint, widthConstraint, centerXConstraint]
    }
    
    fileprivate func doneButtonConstraint() -> [NSLayoutConstraint] {
        let centerXConstraint = NSLayoutConstraint(item: doneButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: doneButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.1, constant: 0.0)
        
        return [centerXConstraint, centerYConstraint]
    }
}