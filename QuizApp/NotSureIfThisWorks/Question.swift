//
//  Question.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/27/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import Foundation

class Question {
    private var _question: String
    private var _answerA: String
    private var _answerB: String
    private var _answerC: String
    private var _answerD: String
    
    init(question: String, answerA: String, answerB: String, answerC: String, answerD: String) {
        _question = question
        _answerA = answerA
        _answerB = answerB
        _answerC = answerC
        _answerD = answerD
    }
    var question: String {
        return _question
    }
    var answerA: String {
        return _answerA
    }
    var answerB: String {
        return _answerB
    }
    var answerC: String {
        return _answerC
    }
    var answerD: String {
        return _answerD
    }
}