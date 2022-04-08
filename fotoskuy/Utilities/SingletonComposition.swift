//
//  SingletonComposition.swift
//  fotoskuy
//
//  Created by Vivaldi Darren Christophilus on 08/04/22.
//

import Foundation

class SingletonComposition {
    var composition = Composition(compositionName: "Rule of Thirds",
                                  compositionSubtitle: "The Rule of Thirds brings focus and balance to your landscape shots.",
                                  compositionBodyText: "The Rule of Thirds places your subject on the left-third or right-third of the frame, creating a pleasing composition.\n\nEach intersection point is a potential point of interest; align your main subject along with other elements of the frame along these points to create a balanced, or visually interesting, image.\n\nRule of Thrids create a sense of expansiveness by positioning the horizon line along the lower third of the grid, drawing the viewer's eye to the sky above.\n\nIn landscape photography, position the horizon along the upper third to draw the eye to the foreground to create a sense of proximity with the landscape.\n\nYou can place an interesting natural feature—a mountain peak or waterfall—on one of the four intersection points to create a focal point.",
                                  compositionImageName: "RuleOfThirds",
                                  compositionGridImageName: "RuleOfThirdsGrid")
    
    static let sharedInstance = SingletonComposition()
    
    private init() {
        
    }
}
