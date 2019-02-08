//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by Bailey Carlson on 1/25/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var YourImageView: UIImageView!
    @IBOutlet weak var ComputerImageView: UIImageView!
    @IBOutlet weak var rockImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet weak var timerLabel: UILabel!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    let gameChoices: [String] = ["rock", "paper", "scissors"]
    var seconds = 3.00
    var currentImageView: UIImageView!
    
    @objc func updateTimer() {
        if YourImageView.image != nil {
            timer.invalidate()
        }
        else if seconds != 0.00 {
            seconds -= 1.00
            timerLabel.text = "\(Int(seconds))"
        }
        else if seconds == 0.00 {
            timer.invalidate()
            seconds = 3.00
            timerLabel.text = "\(Int(seconds))"
            let alert = UIAlertController(title: "You lose! You didn't press anything", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func SafariButtonTapped(_ sender: UIButton) {
        if let myURL = URL(string: "https://en.wikipedia.org/wiki/Rock%E2%80%93paper%E2%80%93scissors") {
            let safariView = SFSafariViewController(url: myURL)
            present(safariView, animated: true, completion: nil)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if seconds == 3.00 {
            timer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func whenTapped(_ sender: UITapGestureRecognizer) {
        if timer == nil || seconds == 3.00 {
            //            let alert = UIAlertController(title: "Error", message: "Please press start!", preferredStyle: .alert)
            //            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            //            alert.addAction(ok)
            //            present(alert, animated: true, completion: nil)
        }
        else {
            let selectedPoint = sender.location(in: stackView)
            for image in images {
                if image.frame.contains(selectedPoint) {
                    YourImageView.image = image.image
                    let yourChoice = image.tag
                    let computerNumber = Int.random(in: 0...2)
                    let computerImage = UIImage(named: gameChoices[computerNumber])
                    ComputerImageView.image = computerImage
                    
                    if yourChoice == computerNumber {
                        let alertController = UIAlertController(title: "Good Game! It was a tie.", message: nil, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                            self.YourImageView.image = nil
                            self.ComputerImageView.image = nil
                        }
                        alertController.addAction(OK)
                        present(alertController, animated: true, completion: nil)
                    }
                    else if yourChoice == 0 && computerNumber == 2 || yourChoice == 1 && computerNumber == 0 || yourChoice == 2 && computerNumber == 1 {
                        let alertController = UIAlertController(title: "Congratulations! You won!", message: nil, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                            self.YourImageView.image = nil
                            self.ComputerImageView.image = nil
                        }
                        alertController.addAction(OK)
                        present(alertController, animated: true, completion: nil)
                    }
                    else {
                        let alertController = UIAlertController(title: "You lost...try again!", message: nil, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                            self.YourImageView.image = nil
                            self.ComputerImageView.image = nil
                        }
                        alertController.addAction(OK)
                        present(alertController, animated: true, completion: nil)
                    }
                    
                    timer.invalidate()
                    seconds = 3
                    timerLabel.text = "\(Int(seconds))"
                }
            }
        }
    }
    @IBAction func whenDoubleTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let selectedPoint = sender.location(in: stackView)
        for image in images {
            if image.frame.contains(selectedPoint) {
                currentImageView = image
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func whenLongPressed(_ sender: UILongPressGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let selectedPoint = sender.location(in: stackView)
        for image in images {
            if image.frame.contains(selectedPoint) {
                currentImageView = image
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let chosenImage = info[.originalImage] as? UIImage {
                self.currentImageView.image = chosenImage
            }
        }
    }
}
