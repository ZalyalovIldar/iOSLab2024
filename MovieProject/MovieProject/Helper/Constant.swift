import Foundation
import UIKit

enum Constant {
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let grayColor = UIColor.init(hex: "242A32")
    static let orangeColor = UIColor.init(hex: "FF8700")
    static let imageMediumCornerRadius: CGFloat = 15
    static let imageCornerRadius: CGFloat = 20
    
    enum Padding {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let xxLarge: CGFloat = 40
        static let xxxLarge: CGFloat = 48
        static let xxxxLarge: CGFloat = 56
    }
    
    enum TabBarController {
        static let backgroundColor = UIColor(hex: "242A32")
        static let unselectedItemTintColor = UIColor(hex: "67686D")
        static let selectedItemTintColor = UIColor(hex: "0296E5")
        static let separatorLineColor = UIColor(hex: "0296E5")
        static let iconHome = "house"
        static let iconFavorites = "bookmark"
        static let titleHome = "Главная"
        static let titleFavorites = "Избранное"
        static let separationViewTopAnchor: CGFloat = 0
        static let separationViewHeightAnchor: CGFloat = 1
    }
    
    enum HomeView {
        static let spaicingStackView: CGFloat = 10
        static let searchBarCornerRadius: CGFloat = 20
        static let collectionViewCornerRadius: CGFloat = 5
        static let collectionViewMinimumLineSpacing: CGFloat = 40
        static let collectionViewMinimumInteritemSpacing: CGFloat = 10
        static let mainTextLabel = "Что вы хотите посмотреть?"
        static let colorTextSearchBar = "67686D"
        static let colorBackgroundSearchBar = "3A3F47"
    }
    
    enum DetailView {
        static let stackViewSpaicing: CGFloat = 10
        static let titleNumberOfLines = 2
        static let descriptionNumberOfLines = 0
        static let colorLabelText = "92929D"
        static let cornerRadiusStackView: CGFloat = 15
        static let mainImagesCornerRadius: CGFloat = 5
    }
    
    enum FavoriteView {
        static let stackViewSpaicing: CGFloat = 5
        static let mainStackViewSpaicing: CGFloat = 10
    }
    
    enum Font {
        static let poppinsMediumItalic = "Poppins-MediumItalic"
        static let poppinsItalic = "Poppins-Italic"
        static let poppinsSemiBold = "Poppins-SemiBold"
        static let poppinsThin = "Poppins-Thin"
        static let poppinsBlack = "Poppins-Black"
        static let poppinsBold = "Poppins-Bold"
        static let poppinsLightItalic = "Poppins-LightItalic"
        static let poppinsRegular = "Poppins-Regular"
        static let poppinsBlackItalic = "Poppins-BlackItalic"
        static let poppinsExtraBold = "Poppins-ExtraBold"
        static let poppinsExtraBoldItalic = "Poppins-ExtraBoldItalic"
        static let poppinsSemiBoldItalic = "Poppins-SemiBoldItalic"
        static let poppinsMedium = "Poppins-Medium"
        static let poppinsLight = "Poppins-Light"
        static let poppinsBoldItalic = "Poppins-BoldItalic"
        static let poppinsExtraLightItalic = "Poppins-ExtraLightItalic"
        static let poppinsThinItalic = "Poppins-ThinItalic"
        static let poppinsExtraLight = "Poppins-ExtraLight"
    }
}
