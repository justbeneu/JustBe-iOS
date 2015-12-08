//
//  AssessmentViewController.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 3/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

protocol AssessmentDelegate: class {
    func assessmentDidFinish(response: Response)
}

class AssessmentViewControllerFactory {
    func assessmentViewController(question: Question) -> AssessmentViewController {
        var assessmentViewController: AssessmentViewController!
        
        switch question.type! {
        case .Boolean:
            assessmentViewController = BooleanAssessmentViewController(question: question)
        case .Number:
            assessmentViewController = NumberAssessmentViewController(question: question)
        case .Emotion:
            assessmentViewController = EmotionAssessmentViewController(question: question)
        case .Percent:
            assessmentViewController = PercentAssessmentViewController(question: question)
        case .MultiSelect:
            assessmentViewController = MultiSelectAssessmentViewController(question: question)
        case .BodyMap:
            break
        }
        
        return assessmentViewController
    }
}

class AssessmentViewController: UIViewController {
    
    var question: Question!
    var nextButtonText: String = "Next"
    weak var delegate: AssessmentDelegate!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var slider: TallSlider!
    @IBOutlet weak var rangeFromLabel: UILabel!
    @IBOutlet weak var rangeToLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var leftResponseButton: UIButton!
    @IBOutlet weak var rightResponseButton: UIButton!
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var multiSelectTableView: UITableView!
    
    @IBAction func nextButtonPressed(sender: UIButton) {
    }
    
    @IBAction func leftResponseButtonPressed(sender: UIButton) {
    }
    
    @IBAction func rightResponseButtonPressed(sender: UIButton) {
    }
    
    init(question: Question) {
        self.question = question
        super.init(nibName: "AssessmentViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Assessment"
        
        nextButton.setTitle(nextButtonText, forState: UIControlState.Normal)
        
        questionLabel.text = question.text
        questionLabel.textColor = UIColor.blackText()
        rangeFromLabel.textColor = UIColor.blackText()
        rangeToLabel.textColor = UIColor.blackText()
        
        let buttons = [nextButton, leftResponseButton, rightResponseButton]
        
        for button in buttons {
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.buttonGreen()
            button.layer.cornerRadius = 4
        }
        
        rightResponseButton.backgroundColor = UIColor.buttonOrange()

        slider.minimumTrackTintColor = UIColor.darkYellow()
        slider.maximumTrackTintColor = UIColor.lightYellow()
        
        navigationItem.hidesBackButton = true
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
}

class BooleanAssessmentViewController: AssessmentViewController {
    override func leftResponseButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: false)
        delegate.assessmentDidFinish(response)
    }
    
    override func rightResponseButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: true)
        delegate.assessmentDidFinish(response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftResponseButton.hidden = false
        rightResponseButton.hidden = false
    }
}

class PercentAssessmentViewController: AssessmentViewController {
    let kMinSliderValue: Float = 0
    let kMaxSliderValue: Float = 100
    
    override func nextButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: slider.value)
        delegate.assessmentDidFinish(response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let rangeText = question.rangeText {
            let (fromText, toText) = rangeTextStringMap[question.rangeText]!
            rangeFromLabel.text = fromText
            rangeToLabel.text = toText
        }
        
        slider.minimumValue = kMinSliderValue
        slider.maximumValue = kMaxSliderValue
        
        slider.hidden = false
        rangeFromLabel.hidden = false
        rangeToLabel.hidden = false
        nextButton.hidden = false
    }
}

class EmotionAssessmentViewController: PercentAssessmentViewController {
    override func nextButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: slider.value)
        delegate.assessmentDidFinish(response)
    }
}

class NumberAssessmentViewController: AssessmentViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var maxValue = 100
    var intervalFactor = 1
    
    override func nextButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: numberPicker.selectedRowInComponent(0))
        delegate.assessmentDidFinish(response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxValue = question.max
        
        if maxValue > 100 {
            intervalFactor = 5
        }
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        numberPicker.hidden = false
        nextButton.hidden = false
    }
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (maxValue / intervalFactor) + 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row * intervalFactor)"
    }
}

class MultiSelectAssessmentViewController: AssessmentViewController, UITableViewDataSource, UITableViewDelegate {
    let multiSelectCellReuseIdentifier = "MultiSelectCellReuseIdentifier"
    var optionStates: [Bool]!
    
    private func selectedOptions() -> [Int] {
        var selectedOptions = [Int]()
        for (idx, optionState) in optionStates.enumerate() {
            if optionState {
                selectedOptions.append(idx)
            }
        }
        return selectedOptions
    }
    
    // MARK: AssessmentViewController
    
    override func nextButtonPressed(sender: UIButton) {
        let response = Response(question: question, value: selectedOptions())
        delegate.assessmentDidFinish(response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionStates = [Bool](count: question.multiSelectOptions.count, repeatedValue: false)
        
        multiSelectTableView.dataSource = self
        multiSelectTableView.delegate = self
        
        multiSelectTableView.tableFooterView = UIView()

        multiSelectTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: multiSelectCellReuseIdentifier)
        
        multiSelectTableView.hidden = false
        nextButton.hidden = false
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.multiSelectOptions.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset.left = CGFloat(0.0)
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins.left = CGFloat(0.0)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            multiSelectCellReuseIdentifier,
            forIndexPath: indexPath
        ) 
        
        cell.textLabel?.text = question.multiSelectOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.blackText()
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        let stateSwitch = UISwitch()
        stateSwitch.tag = indexPath.row
        stateSwitch.on = optionStates[indexPath.row]
        stateSwitch.addTarget(self, action: Selector("optionStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = stateSwitch
        
        return cell
    }
    
    func optionStateChanged(stateSwitch: UISwitch) {
        optionStates[stateSwitch.tag] = stateSwitch.on
    }
    
}
