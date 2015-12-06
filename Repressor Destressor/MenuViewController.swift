//
//  MenuViewController.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

private let CELL_NAME = "ExerciseCell"

protocol MenuViewControllerDelegate
{
    func menuViewControllerDidSelectExercise(menuViewController: MenuViewController, exercise: Exercise)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:MenuViewControllerDelegate?
    
    var exercises = ExerciseManager.sharedInstance.exercises()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: CELL_NAME, bundle: nil), forCellReuseIdentifier: CELL_NAME)
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
    
    // MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.exercises.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(self.view.frame.size.height) / CGFloat(self.exercises.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! ExerciseCell
        
        cell.exercise = self.exercises[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset.left = CGFloat(0.0)
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins.left = CGFloat(0.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (self.delegate != nil)
        {
            self.delegate!.menuViewControllerDidSelectExercise(self, exercise: self.exercises[indexPath.row])
        }
    }
}
