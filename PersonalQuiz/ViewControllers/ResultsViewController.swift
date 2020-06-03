//
//  ResultsViewController.swift
//  PersonalQuiz
//
//  Created by Vladislav on 02.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var definitionLabel: UILabel!
    
    //MARK: - Public properties
    var response: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        showResult()
    }
    
    private func mostPopularAnimal() -> AnimalType{
        let animalTypes = response.map { $0.type }
        var animalsCount: [AnimalType: Int] = [:]
        
        for animalType in animalTypes {
            animalsCount[animalType] = (animalsCount[animalType] ?? 0) + 1
        }
        
        let mostPopularAnymalType = (animalsCount.max { $0.value < $1.value })?.key ?? AnimalType.dog
        
        return mostPopularAnymalType
    }
    
    private func showResult() {
        resultLabel.text = "Вы - \(mostPopularAnimal().rawValue)"
        definitionLabel.text = "\(mostPopularAnimal().definition)"
    }
}
