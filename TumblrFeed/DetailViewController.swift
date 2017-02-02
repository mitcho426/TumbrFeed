//
//  DetailViewController.swift
//  TumblrFeed
//
//  Created by bwong on 2/1/17.
//  Copyright © 2017 mw-hlp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var labelView: UILabel!
    var index: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = "You tapped the cell at index \(index)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
