//
//  MainVC.swift
//  MatchTheMembers
//
//  Created by Su Hyang Kim on 2/6/20.
//  Copyright © 2020 Su Hyang Kim. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func toGameVC(_ sender: Any) {
        self.performSegue(withIdentifier: "toGameVC", sender: self)
    }
    
}

