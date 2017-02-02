//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by bwong on 2/1/17.
//  Copyright © 2017 mw-hlp. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var posts: [NSDictionary] = []
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 240;
        
        
//        let myImageUrlString = "https://i.imgur.com/tGbaZCY.jpg"
        
        // AFNetworking extension to UIImageView that allows
        // specifying a URL for the image
//        imgView.setImageWithURL(NSURL(string: myImageUrlString)! as URL)
        
        // Network request
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
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return posts.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let photos = post.value(forKeyPath: "photos") as! [NSDictionary]
        let temp = photos[0] as? NSDictionary
        let temp2 = temp?.value(forKey: "original_size") as? NSDictionary
        let temp3 = temp2?.value(forKey: "url") as? URL
        
        cell.postImageView.setImageWith((temp3?)!)
        
        return cell
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
////        } else {
//            // photos is nil. Good thing we didn't try to unwrap it!
////        }
//        // Configure YourCustomCell using the outlets that you've defined.
//        
//        return cell
//    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let detailViewController = segue.destination as! DetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        detailViewController.index = index
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
