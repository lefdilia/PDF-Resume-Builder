//
//  Colors+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/11/2021.
//

import UIKit

//MARK: - For Dark Mode
extension UIColor {
    static var apBackground = UIColor(named: "apBackground")!
    
    static var apTintColor = UIColor(named: "apTintColor")!
    static var apTintColorLight = UIColor(named: "apTintColor")!.withAlphaComponent(0.8)

    static var apTextFieldBorder = UIColor(named: "apTextFieldBorder")!
    static var apTextFieldHolder = UIColor(named: "apTextFieldHolder")!
    static var apTextFieldTextColor = UIColor(named: "apTextFieldTextColor")!
    static var apTextFieldImageColor = UIColor(named: "apTextFieldImageColor")!
    static var apBrandyRose = UIColor(named: "apBrandyRose")!
    static var apLocationBackground = UIColor(named: "apLocationBackground")!
    static var apDotColor = UIColor(named: "apDotColor")!
    
    static var apBorder = UIColor(named: "apBorder")!
    static var apGradientFirst = UIColor(named: "apGradientFirst")!
    static var apGradientLast = UIColor(named: "apGradientLast")!
    static var apSettingsBackground = UIColor(named: "apSettingsBackground")!
    static var apSettingsTintColor = UIColor(named: "apSettingsTintColor")!
    static var apJobCellImageBackground = UIColor(named: "apJobCellImageBackground")!
    static var apBorderJobCell = UIColor(named: "apBorderJobCell")!
    static var apLinkColor = UIColor(named: "apLinkColor")!
    
    static var apChooseTemplate = UIColor(named: "apChooseTemplate")!
    static var apApplyOnSite = UIColor(named: "apApplyOnSite")!
    static var apSocialLinksButton = UIColor(named: "apSocialLinksButton")!
    static var apTrashButton = UIColor(named: "apTrashButton")!
    static var apUpdateButton = UIColor(named: "apUpdateButton")!
    static var apContinueButton = UIColor(named: "apContinueButton")!
    static var apMainSectionCellBorder = UIColor(named: "apMainSectionCellBorder")!
    static var apAddLabel = UIColor(named: "apAddLabel")!

    //Swiping Pages..
    static var apSwipeBackground = UIColor(named: "apSwipeBackground")!
    static var apSwipeNextButtonText = UIColor(named: "apSwipeNextButtonText")!
    static var apSwipeNextButton = UIColor(named: "apSwipeNextButton")!
    static var apSwipeNextButtonLight = apSwipeNextButton.withAlphaComponent(0.5)

}

//MARK: - Template
extension UIColor {

    //.RegalBlue
    static var regalBlue = UIColor(named: "regalBlue")
    static var prussianBlue = UIColor(named: "prussianBlue")
    
    //.GladeGreen
    static let gladeGreen = UIColor(named: "gladeGreen")
    static let tomThumb = UIColor(named: "tomThumb")
    
    //.CopperRose
    static let copperRose = UIColor(named: "copperRose")
    static let ferra = UIColor(named: "ferra")
    static let thatch = UIColor(named: "thatch")
    static let cocoaBrown = UIColor(named: "cocoaBrown")
    
    //.HippiePink
    static let hippiePink = UIColor(named: "hippiePink")
    static let lotus = UIColor(named: "lotus")
    static let buccaneer = UIColor(named: "buccaneer")
    
    //.Contessa
    static let contessa = UIColor(named: "contessa")
    static let copperRust = UIColor(named: "copperRust")
    
    //.Mongoose
    static let mongoose = UIColor(named: "mongoose")
    static let domino = UIColor(named: "domino")

    //CuttySark
    static let cuttySark = UIColor(named: "cuttySark")
    static let riverBed = UIColor(named: "riverBed")
    
}

//Colors StackView
struct TemplateColors {
    static var colors: [UIColor?] = [.regalBlue, .gladeGreen, .copperRose, .hippiePink, .contessa, .mongoose, .cuttySark]
}

//MARK: - Global
extension UIColor {
        
    /// #EBEBEB - 100%
    static let gallery: UIColor = UIColor(named: "gallery")!
    
    /// #C6C6C8 - 100%
    static let fillFrenchGray: UIColor = UIColor(named: "fill_french_gray")!

    /// #000000 - 100%
    static let labelBlack: UIColor = UIColor(named: "label_black")!

    /// #007AFF - 100%
    static let systemColorAzureRadiance: UIColor = UIColor(named: "system_color_azure_radiance")!

    /// #8E8E93 - 100%
    static let systemGrayManatee: UIColor = UIColor(named: "system_gray_manatee")!

    /// #999999 - 100%
    static let systemGrayDustyGray: UIColor = UIColor(named: "system_gray_dusty_gray")!

    /// #007AFF - 100%
    static let labelAzureRadiance: UIColor = UIColor(named: "label_azure_radiance")!

    /// #808083 - 100%
    static let jumbo: UIColor = UIColor(named: "jumbo")!

    /// #007AFF - 100%
    static let azureRadiance: UIColor = UIColor(named: "azure_radiance")!

    /// #C5C5C5 - 50%
    static let silver: UIColor = UIColor(named: "silver")!

    /// #FFE9DD - 100% | 41%
    static let derby: UIColor = UIColor(named: "derby")!
    static let derbyLight: UIColor = UIColor(named: "derbyLight")!

    /// #E5989B - 100%
    static let tonysPink: UIColor = UIColor(named: "tonys_pink")!
    
    /// #FFB4A2 - 100%
    static let waxFlower: UIColor = UIColor(named: "waxFlower")!
    
    /// #E0DADA - 100%
    static let swissCoffee: UIColor = UIColor(named: "swissCoffee")!
    
    /// #EEE0DD - 100%
    static let bizarre: UIColor = UIColor(named: "bizarre")!

    /// #F2A69E - 100%
    static let wewak: UIColor = UIColor(named: "wewak")!

    /// #B5838D - 100%
    static let brandyRose: UIColor = UIColor(named: "brandy_rose")!

    /// #273D52 - 100% | 5%
    static let rhino: UIColor = UIColor(named: "rhino")!
    static let rhinoLight: UIColor = UIColor(named: "rhino_light")!

    /// #6D6875 - 100% | 41%
    static let saltBox: UIColor = UIColor(named: "salt_box")!
    static let saltBoxLight: UIColor = UIColor(named: "salt_box_light")!
    
    ///  #4C4C4C - 100% (Like saltBox [Explore Icon])
    static let tundora: UIColor = UIColor(named: "tundora")!
    
    static let tundoraLight: UIColor = UIColor(named: "tundora_light")!
    
    /// #0E76A8 - 100%
    static let blueChill: UIColor = UIColor(named: "blue_chill")!

    ///  #D8D8D8 - 100% ( Alto [Apply view border])
    static let alto: UIColor = UIColor(named: "alto")!
    
    /// #0E2031 - 100%
    static let firefly: UIColor = UIColor(named: "firefly")!

    /// #E5ECED - 100%
    static let mystic: UIColor = UIColor(named: "mystic")!

    /// #D1D9DA - 50.8003715034965%
    static let iron: UIColor = UIColor(named: "iron")!

    /// #65C897 - 100%
    static let emerald: UIColor = UIColor(named: "emerald")!

    /// #B54047 - 100%
    static let appleBlossom: UIColor = UIColor(named: "apple_blossom")!

    /// #62DA98 - 100%
    static let pastelGreen: UIColor = UIColor(named: "pastel_green")!

    /// #52A3F2 - 100%
    static let cornflowerBlue: UIColor = UIColor(named: "cornflower_blue")!

    /// #DC3545 - 100%
    static let punch: UIColor = UIColor(named: "punch")!

    /// #F08080 - 100%
    static let froly: UIColor = UIColor(named: "froly")!

    /// #707070 - 100%
    static let doveGray: UIColor = UIColor(named: "dove_gray")!

    /// #0A66C2 - 100%
    static let scienceBlue: UIColor = UIColor(named: "science_blue")!

    /// #627D98 - 100%
    static let lynch: UIColor = UIColor(named: "lynch")!

}


extension UIColor { /* External Setting Title & slogan [Settings VC] */

    static let lightGray = UIColor(named: "lightGray")                  //#6A6A70 // Setting Head title
    static let neebGray = UIColor(named: "neebGray")                    //#181718 // Setting Title & slogan
    static let lightDark = UIColor(named: "lightDark")                  //#3E3D42
    static let MRed = UIColor(named: "MRed")                            //#E63946
    static let SettingBackground = UIColor(named: "SettingBackground")  //#F7F7FA
    
}
