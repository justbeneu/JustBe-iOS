//
//  SettingsCell.swift
//  Just Be
//
//  Created by Gavin King on 4/21/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.setStyle()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.setStyle()
    }
    
    func setStyle()
    {
        self.label.font = UIFont.systemFontOfSize(self.label.font.pointSize)
        self.value.font = UIFont.systemFontOfSize(self.value.font!.pointSize)
        
        self.label.textColor = UIColor.blackText()
        self.value.textColor = UIColor.grayText()
        
        self.label.text = nil;
        self.value.text = nil;
    }
}
