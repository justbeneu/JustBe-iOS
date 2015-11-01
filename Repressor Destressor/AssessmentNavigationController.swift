//
//  AssessmentNavigationController.swift
//  Just Be
//
//  Created by Gavin King on 5/6/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class AssessmentNavigationController: UINavigationController, AssessmentDelegate
{
    var assessmentViewControllers: [AssessmentViewController]!
    var responses: [Response] = []
    var assessmentIndex: Int = 0
    var assessment: Assessment!
    
    private func showNextAssessment()
    {
        if assessmentIndex < assessmentViewControllers.count
        {
            self.setViewControllers([assessmentViewControllers[assessmentIndex]], animated: false)
            assessmentIndex++
        }
        else
        {
            self.showLoader()
            
            ServerRequest.sharedInstance.completeAssessment(responses,
                always: { () -> () in
                    self.hideLoader()
                },
                success: { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                },
                failure: { (error, message) -> () in
                    self.showErrorAlert()
            })
        }
    }
    
    // MARK: - AssessmentDelegate
    
    func assessmentDidFinish(response: Response) {
        response.assessmentId = self.assessment.id!
        responses.append(response)
        showNextAssessment()
    }
    
    // MARK: - Questions
    
    private func shuffledQuestions() -> [Question]
    {
        let path = NSBundle.mainBundle().pathForResource("Questions", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)!
        
        var questionsJson: [AnyObject]!
        if self.assessment.isMomentary! {
            questionsJson = dictionary["Momentary"] as! Array
        } else {
            questionsJson = dictionary["Daily"] as! Array
        }
        
        let questionMapper = Mapper<Question>()
        
        let questions: [Question] = questionMapper.mapArray(questionsJson)!
        let categories: Set<String> = categoriesInQuestions(questions)
        
        var questionsByCategory: [[Question]] = [[Question]]()
        for category in categories {
            questionsByCategory.append(questions.filter({(question: Question) -> Bool in
                question.category == category
            }))
        }
        
        let shuffledQuestionsByCategory = shuffleCategories(questionsByCategory)
        let flattenedQuestions = shuffledQuestionsByCategory.reduce([], combine: +)
        
        return flattenedQuestions
    }
    
    private func categoriesInQuestions(questions: [Question]) -> Set<String> {
        var categories: Set<String> = []
        for question in questions {
            categories.insert(question.category)
        }
        return categories
    }
    
    private func shuffleCategories(categories: [[Question]]) -> [[Question]] {
        // Pull out Mindfulness category
        var mutableCategories: [[Question]] = Array(categories)
        var mindfulnessCategory: [Question]!
        var mindfulnessIndex: Int!
        for (idx, category) in categories.enumerate() {
            if category.first?.category == "Mindfulness" {
                mindfulnessIndex = idx
                mindfulnessCategory = mutableCategories.removeAtIndex(idx)
                break
            }
        }
        
        // Shuffle
        mutableCategories = shuffled(mutableCategories)
        mutableCategories = mutableCategories.map { self.shuffledQuestions($0) }
        
        // Add Mindfullness back
        if let mindfulnessCategory = mindfulnessCategory {
            mutableCategories.insert(mindfulnessCategory, atIndex: mindfulnessIndex)
        }
        
        return mutableCategories
    }
    
    private func shuffledQuestions(questions: [Question]) -> [Question] {
        // Don't shuffle Symptoms category
        if questions.first?.category == "Symptoms" {
            return questions
        }
        
        return shuffled(questions)
    }
    
    // Found on the internet.
    // http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    private func shuffled<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = list.count
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    // MARK: - UINavigationController
    
    init(assessment: Assessment)
    {
        super.init(nibName: "AssessmentNavigationController", bundle: nil)
        
        self.assessment = assessment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let questions: [Question] = shuffledQuestions()
        let assessmentViewControllerFactory = AssessmentViewControllerFactory()
        
        assessmentViewControllers = questions.map { assessmentViewControllerFactory.assessmentViewController($0) }
        
        for assessmentViewController in assessmentViewControllers {
            assessmentViewController.delegate = self
        }
        
        assessmentViewControllers.last?.nextButtonText = "Done"
        
        showNextAssessment()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        self.presentViewController(navController, animated: false, completion: nil)
//    }
}
