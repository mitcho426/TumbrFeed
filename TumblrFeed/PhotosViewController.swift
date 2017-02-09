//
//  PhotoViewController.swift
//  tumblrPro
//
//  Created by mwong on 2/2/17.
//  Copyright © 2017 mwong. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Initialize posts as an empty array so it will not be nil
    var posts: [NSDictionary] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240;
        
        // Do any additional setup after loading the view.
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = UITableViewCell()
        //        cell.textLabel?.text = "This is row \(indexPath.row)"
        
//        
//       cell.textLabel?.text = "This is row \(indexPath.row)"
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = self.posts[indexPath.row]
        
        // Configure YourCustomCell using the outlets that you've defined.
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        
        // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageUrl = NSURL(string: imageUrlString!)
        cell.imgView.setImageWith(imageUrl as! URL)
//
        return cell
    }
    
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
    //        let post = self.posts[indexPath.row]
    //
    //        // Configure YourCustomCell using the outlets that you've defined.
    //        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
    //
    //        // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
    //        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
    //
    //        let imageUrl = NSURL(string: imageUrlString!)
    //
    //        cell.imgView.setImageWith(imageUrl as! URL)
    //
    //        return cell
    //    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        // Get URL
        let post = self.posts[(indexPath?.row)!]
        
        // Configure YourCustomCell using the outlets that you've defined.
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        
        // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageUrl = NSURL(string: imageUrlString!)
        
        let destinationViewController = segue.destination as! PhotosDetailViewController
        
        destinationViewController.URL = imageUrlString!
//        
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
//        let movie = movies![indexPath!.row]
//        
//        let detailViewController = segue.destination as! DetailViewController
//        
//        detailViewController.movie = movie
        
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
