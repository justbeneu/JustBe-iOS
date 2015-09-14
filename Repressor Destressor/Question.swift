//
//  Question.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 4/8/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

enum QuestionType: String
{
    case Boolean = "Boolean"
    case Number = "Number"
    case Emotion = "Emotion"
    case Percent = "Percent"
    case MultiSelect = "Multiselect"
    case BodyMap = "BodyMap"
}

enum Emotion: String
{
    case Upset = "Upset"
    case Angry = "Angry"
    case Sad = "Sad"
    case Depressed = "Depressed"
    case Nervous = "Nervous"
    case Anxious = "Anxious"
    case Happy = "Happy"
    case Content = "Content"
    case Excited = "Excited"
    case Energetic = "Energetic"
    case Relaxed = "Relaxed"
    case Alert = "Alert"
    case Stressed = "Stressed"
}

enum RangeText: Int
{
    case NotAtAllToExtremely = 0
    case NotAtAllToVeryStrongly = 1
    case MomentarilyToVeryLongTime = 2
    case VeryRestedToVeryTired = 3
    case NotAtAllToVeryMuchSo = 4
}

let rangeTextStringMap:[RangeText: (String, String)] = [
    .NotAtAllToExtremely: ("NOT AT ALL", "EXTREMELY"),
    .NotAtAllToVeryStrongly: ("NOT AT ALL", "VERY STRONGLY"),
    .MomentarilyToVeryLongTime: ("MOMENTARILY", "VERY LONG TIME"),
    .VeryRestedToVeryTired: ("VERY RESTED", "VERY TIRED"),
    .NotAtAllToVeryMuchSo: ("NOT AT ALL", "VERY MUCH SO")
]


class Question: Mappable {
    var id: Int!
    var text: String!
    var type: QuestionType!
    var emotion: Emotion!
    var rangeText: RangeText!
    var category: String!
    var max: Int!
    var multiSelectOptions: [String]!
    
    let questionTypeTransform = TransformOf<QuestionType, String>(
        fromJSON: { (value: String?) -> QuestionType? in
            return QuestionType(rawValue: value!)
        }, toJSON: { (value: QuestionType?) -> String? in
            return value?.rawValue
        }
    )
    
    let emotionTransform = TransformOf<Emotion, String>(
        fromJSON: { (value: String?) -> Emotion? in
            if let value = value {
                return Emotion(rawValue: value)
            }
            return nil
        }, toJSON: { (value: Emotion?) -> String? in
            return value?.rawValue
        }
    )
    
    let rangeTextTransform = TransformOf<RangeText, Int>(
        fromJSON: { (value: Int?) -> RangeText? in
            if let value = value {
                return RangeText(rawValue: value)
            }
            return nil
        }, toJSON: { (value: RangeText?) -> Int? in
            return value?.rawValue
        }
    )
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        text <- mapper["text"]
        type <- (mapper["type"], questionTypeTransform)
        emotion <- (mapper["emotion"], emotionTransform)
        rangeText <- (mapper["range_text"], rangeTextTransform)
        category <- mapper["category"]
        max <- mapper["max"]
        multiSelectOptions <- mapper["multi_select_options"]
    }
}
