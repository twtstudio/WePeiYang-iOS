//
//  TwentyCourseDetailViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import pop

class TwentyCourseDetailViewController: UITableViewController {

    var detailList: [Courses.Study20.Detail?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Eliminate the empty cells
        tableView.tableFooterView = UIView()
        
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        
        //FIXME: Autolayout and Scrolling is bad. 
        let bgView = UIView(frame: CGRect(x: 0, y: -(self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height), width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        //let bgView = UIView(color: partyRed)
        bgView.backgroundColor = partyRed
        tableView.addSubview(bgView)
        /*bgView.snp_makeConstraints {
            make in
            make.left.equalTo(0)
            make.top.equalTo(-(self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
            make.right.equalTo((navigationController?.view)!.snp_right)
            make.height.equalTo(self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height)
        }*/
        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        for foo in navigationController!.view.subviews {
            if foo.isKindOfClass(CourseDetailReadingView) {
                foo.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.word("hi\(detailList.count)")
        // #warning Incomplete implementation, return the number of rows
        return detailList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CourseDetailTableViewCell(detail: detailList[indexPath.row]!)

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {


        let readingView = CourseDetailReadingView(detail: detailList[indexPath.row]!)
        
        self.navigationController?.view.addSubview(readingView)
        //animate(to: readingView)
        
        
        //UIView.beginAnimations("", context: UnsafeMutablePointer<Void>)
        
        UIView.animateWithDuration(0.5, animations: {
            readingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.bounds.height)
        }) { (_: Bool) in
                self.navigationController?.view.addSubview(readingView)
                readingView.snp_makeConstraints {
                    make in
                    make.top.equalTo(self.view)
                    make.left.equalTo(self.view)
                    make.bottom.equalTo(self.view)
                    make.right.equalTo(self.view)
                }

        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TwentyCourseDetailViewController {
    convenience init(details: [Courses.Study20.Detail?]) {
        
        self.init()
        self.detailList = details

    }
}

extension TwentyCourseDetailViewController {
    func animate(to Who: UIView) {
        
        let anim = POPSpringAnimation(propertyNamed: kPOPViewBounds)
        anim.fromValue = NSValue(CGRect: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width * 0.85, height: self.view.bounds.height))
        anim.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        anim.velocity = NSValue(CGPoint: CGPointMake(8, 8))
        anim.springBounciness = 20
        Who.layer.pop_addAnimation(anim, forKey: "readingViewPopOut")
        
    }
}
