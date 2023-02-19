//
//  BattleViewController.swift
//  TechMon
//
//  Created by あらいゆめ on 2023/02/19.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLavel:UILabel!
    @IBOutlet var playerImageView:UIImageView!
    @IBOutlet var playerHPLabel:UILabel!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    @IBOutlet var enemyNameLavel:UILabel!
    @IBOutlet var enemyImageView:UIImageView!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyMPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP: Int = 100
    var playerMP: Int = 0
    
    var enemyHP: Int = 200
    var enemyMP:Int = 0
    
    var player: Character!
    var enemy: Character!
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        
        playerNameLavel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP)/100"
        playerMPLabel.text = "\(playerMP)/20"
        
        
        enemyNameLavel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP)/200"
        enemyMPLabel.text = "\(enemyMP)/35"
        
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.1, target: self, selector: #selector(updataGame), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP)/\(enemy.maxMP)"
    }
    
    @objc func updataGame(){
        playerMP += 1
        if playerMP > 20 {
            isPlayerAttackAvailable = true
            playerMP = 20
        }else{
            isPlayerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP >= 35{
            enemyAttack()
            enemyMP = 0
        }
        
        playerMPLabel.text = "\(playerMP)/20"
        enemyMPLabel.text = "\(enemyMP)/35"
        
    }
    
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        playerMPLabel.text = "\(playerMP)/20"
        
        if playerHP < 0{
            finishBattle(vanishImageView: playerImageView, isPlayerwin: false)
        }
    }
    
    func judgeBatle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerwin: false)
        }else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerwin: true)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerwin: Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerwin{
            
            techMonManager.playSE(fileName:  "SE_fanfare")
            finishMessage = "勇者の勝利！"
        }else{
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北"
        }
        
        let alart = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alart.addAction(UIAlertAction(title: "OK", style: .default,handler: {
            _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alart,animated: true, completion: nil)
    }
    
    @IBAction func attackAction(){
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP -= player.attackPoint
            player.currentTP += 10
            if player.currentTP >= player.maxTP {
                player.currentTP = player.maxTP
            }
            
            player.currentMP = 0
            
            judgeBatle()
            
//            enemyHP -= 30
//            playerHP = 0
//
//            enemyHPLabel.text = "\(enemyHP)/200"
//            playerMPLabel.text = "\(playerMP)/20"
//
//            if enemyHP <= 0{
//                finishBattle(vanishImageView: enemyImageView, isPlayerwin: true)
//            }
        }
    }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailable && player.currentTP >= 40 {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            
            judgeBatle()
        }
    }
    
    
    @IBAction func tameruAction(){
        
        if isPlayerAttackAvailable{
            
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP {
                
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
        }
    }
    
}
