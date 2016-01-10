//
//  Responses.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 4/8/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class Response: NSObject {
    var assessmentId: Int!
    var questionId: Int!
    var questionType: QuestionType!
    var value: AnyObject!
    var emotion: Emotion!
    var category: String!
    
    let questionTypeIntMap:[QuestionType: Int] = [
        .Boolean: 0,
        .Number: 1,
        .Emotion: 2,
        .Percent: 3,
        .MultiSelect: 4,
        .BodyMap: 5
    ]
    
    let questionTypeKeyMap:[QuestionType: String] = [
        .Boolean: "boolean",
        .Number: "number",
        .Emotion: "emotion",
        .Percent: "percent",
        .MultiSelect: "muti_selects",
        .BodyMap: "body_map_locations"
    ]
    
    let emotionIntMap:[Emotion: Int] = [
        .Upset: 1,
        .Angry: 2,
        .Sad: 3,
        .Depressed: 4,
        .Nervous: 5,
        .Anxious: 6,
        .Happy: 7,
        .Content: 8,
        .Excited: 9,
        .Energetic: 10,
        .Relaxed: 11,
        .Alert: 12,
        .Stressed: 13
    ]
    
    convenience init(question: Question, value: AnyObject) {
        self.init()
        self.questionId = question.id!
        self.questionType = question.type
        self.value = value
        self.emotion = question.emotion
    }
    
    func jsonValue() -> [String: AnyObject] {
        let questionTypeInt: Int = questionTypeIntMap[questionType!]!
        
        var json = [
            "assessment_id": assessmentId,
            "question_id": questionId,
            "category" : category,
            "type": questionTypeInt,
            questionType.rawValue.lowercaseString: value!
        ]
        
        if questionType == .Emotion {
            let emotionInt: Int = emotionIntMap[emotion!]!
            json.update(["percent": value, "emotion": emotionInt])
        } else if questionType == .MultiSelect {
            let selections: Array = value as! [Int]
            let multiSelects = selections.map() { ["selection_id": $0] }
            json.update(["multi_selects": multiSelects])
            json.removeValueForKey(questionType.rawValue.lowercaseString)
        }
        
        return json
    }
    
    override var description: String {
        return String(stringInterpolationSegment: jsonValue())
    }
}
