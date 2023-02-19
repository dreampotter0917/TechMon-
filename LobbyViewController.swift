//
//  LobbyViewController.swift
//  TechMon
//
//  Created by あらいゆめ on 2023/02/19.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina)/100"
        
        staminaTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfo: nil,
            repeats: true)
        staminaTimer.fire()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @IBAction func toBattle(){
        if stamina >= 50{
            stamina -= 50
            staminaLabel.text = "\(stamina)/100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alart = UIAlertController(
                title: "バトルに行けません",
                message: "スタミナを貯めてください",
                preferredStyle: .alert)
            alart.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            present(alart, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func updateStaminaValue(){
        if stamina <= 100{
            stamina += 1
            staminaLabel.text = "\(stamina)/100"
        }
    }
    

    

}
