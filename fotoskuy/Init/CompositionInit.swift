//
//  CompositionInit.swift
//  fotoskuy
//
//  Created by Michael Ricky on 07/04/22.
//

import Foundation

func initCompData() -> [Composition] {
    var compositionCollections = [Composition]()
    
    compositionCollections.append(
        Composition(compositionName: "Rule of Thirds",
                    compositionSubtitle: "The Rule of Thirds brings focus and balance to your landscape shots.",
                    compositionBodyText: "The Rule of Thirds places your subject on the left-third or right-third of the frame, creating a pleasing composition.\n\nEach intersection point is a potential point of interest; align your main subject along with other elements of the frame along these points to create a balanced, or visually interesting, image.\n\nRule of Thrids create a sense of expansiveness by positioning the horizon line along the lower third of the grid, drawing the viewer's eye to the sky above.\n\nIn landscape photography, position the horizon along the upper third to draw the eye to the foreground to create a sense of proximity with the landscape.\n\nYou can place an interesting natural feature—a mountain peak or waterfall—on one of the four intersection points to create a focal point.",
                    compositionImageName: "RuleOfThirds",
                    compositionGridImageName: "RuleOfThirdsGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Golden Spiral",
                    compositionSubtitle: "Golden Spiral leads viewers eyes through an image with a natural flow.",
                    compositionBodyText: "It’s an excellent technique to use when you have a single subject in a wide-angle shot or a single focal point in a landscape.\n\nYou should place the area with the most details in the smallest box of the coil. This does not have to be in one of the corners. It can be anywhere in the frame.\n\nTry to place your subject at the very end of the spiral for the best composition.The spiral works by focusing the viewer’s eye on the end of the spiral and then leading them outwards to the whole scene.\n\nThe great thing about the spiral is that it works from all angles. You can mirror the original spiral, flip it upside down or place it in any direction.\n\nIf your scene full of straight objects or line, don't try to force them in to the spiral, and consider using the Golden Section (phi grid) instead.",
                    compositionImageName: "GoldenSpiral",
                    compositionGridImageName: "GoldenSpiralGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Golden Triangle",
                    compositionSubtitle: "Golden Triangle rule is a series of diagonal lines that form right-angle triangles act as a composition guide.",
                    compositionBodyText: "Golden triangle photography is a composition technique used in photography. According to the golden triangle rule, a frame is divided into four triangles by drawing a diagonal line and the perpendicular bisectors of this line from the other two corners of the frame.\n\nTo follow this composition rule, the subjects/area of interest must fall on the two points of intersection or these three lines or inside these triangles.\n\nThe main subject of the photo should sit on the intersection of these triangles.\n\nYou can use the main diagonal line or the two perpendicular bisectors as the leading lines to the subject of interest.\n\nPut the subject in the picture can be inside these triangles to make the frame aesthetically more pleasing.",
                    compositionImageName: "GoldenTriangle",
                    compositionGridImageName: "GoldenTriangleGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Phi Grid",
                    compositionSubtitle: "The Phi Grid is another way to visualize the golden ratio.",
                    compositionBodyText: "Rectangles can be superimposed over an image in a grid based on the 1:1.618 ratio. This “phi grid” divides your scene into thirds, both horizontally and vertically. But unlike the more popular rule of thirds, the center lines in the Phi Grid are closer together.\n\nYou can see when using the Phi Grid is in the spaces where gridlines intersect. These so-called “sweet spots” are places where the eye is naturally drawn in an image.\n\nWhen framing on the Phi Grid you can put the subject remains the center of affection by keeping it centralized.\n\nAligning an image so that key parts fall in these areas will create focus and harmony. The phi grid is best suited for photographs with many lines in them.",
                    compositionImageName: "PhiGrid",
                    compositionGridImageName: "PhiGridGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Symmetrical Line",
                    compositionSubtitle: "Symmetrical Line helps to achive same weight and give a perfect balance between two sides in photo.",
                    compositionBodyText: "Symmetry appears when parts of your composition mirror other parts. It is created when two halves of your scene look the same and balance each other out.\n\nSymmetry defines something being clean, proportional and balanced and will make pictures appear neat, tidy and clinical.\n\nFor perfect symmetry, create an image that is centered on a point in the middle, around which everything else radiates. This is possible if your subject is symmetrical from side to side, or from top to bottom.\n\nUsing the center as a focal point will allow you to create a dramatic, if unsettling, image.\n\nPosition your focal point along one of the lines or on one of the four intersections. This naturally places the point of focus off-center, creating aesthetically pleasing images through asymmetry.",
                    compositionImageName: "SymmetricalLine",
                    compositionGridImageName: "SymmetricalLineGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Diagonal Line",
                    compositionSubtitle: "Diagonal lines in photography create dynamic tension. Sometimes they create a sense of uncertainty.",
                    compositionBodyText: "Diagonal lines are a compositional element that stretches diagonally across a photo. They guide the eye through the frame, carefully taking the viewer through the photograph. Diagonal lines help to create depth, a sense of tension, and dynamism.\n\nThe most dynamic placement of diagonal lines is to lead into the image from the corner. You don’t, however, have to place the diagonal line exactly in the corner. It can be offset. It all depends on what you want to do with the diagonal line.\n\nYou can use a wide angle and a low viewpoint on a vertical line to increase the distortion and make it even more diagonal.\n\nWhen diagonal lines intersect each other they create points of interest at the intersection. It’s ideal to place the focal point of the image at an intersection, because our eyes are naturally drawn to the intersection of two lines.\n\nLook for actual diagonal lines to include in a scene. These are the easiest diagonal lines to use, because you just need to look around you to see them.",
                    compositionImageName: "DiagonalLine",
                    compositionGridImageName: "DiagonalLineGrid")
    )
    
    compositionCollections.append(
        Composition(compositionName: "Off",
                    compositionSubtitle: "Off",
                    compositionBodyText: "Off",
                    compositionImageName: "Off",
                    compositionGridImageName: "Off")
    )
    
    return compositionCollections
}
