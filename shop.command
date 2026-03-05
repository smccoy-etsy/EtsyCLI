#!/usr/bin/swift

import Foundation

// Constants
// To get an API Key and Auth Token, refer to https://docs.google.com/document/d/1Fw8tHi1mAWqcmVT8aHWL4jUQHYEYHiBnTi6sqlp7aLs/edit?tab=t.0
let apiKey = ""
let authToken = ""

// Validate input
guard CommandLine.arguments.count >= 2 else {
    printError("need arg")
    exit(1)
}

let endIndex = CommandLine.arguments.count - 1

for shopId in CommandLine.arguments[1...endIndex] {
    getShopInfo(shopId: shopId)
}


func getShopInfo(shopId: String) {

    

    // Set up url
    let url = "https://openapi.etsy.com/etsyapps/v3/bespoke/member/shops/\(shopId)/home"

    // Set up command
    let command = """
    curl --silent --location \"\(url)\" \
    --header "x-api-key: \(apiKey)" \
    --header "user-agent: Dalvik/2.1.0 (Linux; U; Android 14; SM-F721U1 Build/UP1A.231005.007) Mobile/1 EtsyEnterprise/7.29.0.138 Android/1" \
    --header "Authorization: Bearer \(authToken)" | jq
    """

    let shopHome:Welcome = decodeJsonFromCommand(
        command: command
    )



    print("\(shopHome.shop.shopID)\t\(shopHome.shop.shopName)\t\(shopHome.shop.activeListingCount)")

}



// MARK: Funcs
func decodeJsonFromCommand<T: Decodable>(command: String) -> T {
    do {
        let json = try shell(command)
        //print(json)


        guard let data = json.data(using: .utf8) else {
            printError("error: Could not convert json String to Data")
            exit(1)        
        }
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        printError("error: \(error)")
        exit(1)
    }
}



func printError(_ message: String) {
    fputs(message + "\n", stderr)
}

@discardableResult // Add to suppress warnings when you don't want/need a result
func shell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}




// MARK: Structs

//⠸⣷⣦⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠀⠀⠀
//⠀⠙⣿⡄⠈⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠉⣿⡿⠁⠀⠀⠀
//⠀⠀⠈⠣⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⣰⠟⠀⠀⠀⣀⣀
//⠀⠀⠀⠀⠈⠢⣄⠀⡈⠒⠊⠉⠁⠀⠈⠉⠑⠚⠀⠀⣀⠔⢊⣠⠤⠒⠊⠉⠀⡜
//⠀⠀⠀⠀⠀⠀⠀⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⡔⠊⠁⠀⠀⠀⠀⠀⠀⠇
//⠀⠀⠀⠀⠀⠀⠀⡇⢠⡤⢄⠀⠀⠀⠀⠀⡠⢤⣄⠀⡇⠀⠀⠀⠀⠀⠀⠀⢰⠀
//⠀⠀⠀⠀⠀⠀⢀⠇⠹⠿⠟⠀⠀⠤⠀⠀⠻⠿⠟⠀⣇⠀⠀⡀⠠⠄⠒⠊⠁⠀
//⠀⠀⠀⠀⠀⠀⢸⣿⣿⡆⠀⠰⠤⠖⠦⠴⠀⢀⣶⣿⣿⠀⠙⢄⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠿⡿⠛⢄⠀⠀⠱⣄⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⢸⠈⠓⠦⠀⣀⣀⣀⠀⡠⠴⠊⠹⡞⣁⠤⠒⠉⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⡌⠉⠉⡤⠀⠀⠀⠀⢻⠿⠆⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠰⠁⡀⠀⠀⠀⠀⢸⠀⢰⠃⠀⠀⠀⢠⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⢶⣗⠧⡀⢳⠀⠀⠀⠀⢸⣀⣸⠀⠀⠀⢀⡜⠀⣸⢤⣶⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠈⠻⣿⣦⣈⣧⡀⠀⠀⢸⣿⣿⠀⠀⢀⣼⡀⣨⣿⡿⠁⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠈⠻⠿⠿⠓⠄⠤⠘⠉⠙⠤⢀⠾⠿⣿⠟⠋
//




// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let shop: Shop
    let manufacturers: [JSONAny]
    let policies: Policies
    let shopAbout: ShopAbout
    let featuredListings, displayListings: [JSONAny]
    let reviews: Reviews
    let sections: [JSONAny]
    let structuredPolicies: StructuredPolicies
    let reviewVideosCount: Int
    let faq: [FAQ]
    let listingCards: [JSONAny]
    let goToCartNudger: JSONNull?
    let bestSellers: [JSONAny]
    let favoriteShopsCount: FavoriteShopsCount
    let promotionBanner: JSONNull?
    let signals: Signals
    let returnPolicies: ReturnPolicies
    let listingSortOrder: String
    let banners: JSONNull?
    let listingCount: String
    let feedPaginationKey: JSONNull?
    let memberData: MemberData

    enum CodingKeys: String, CodingKey {
        case shop, manufacturers, policies
        case shopAbout = "shop_about"
        case featuredListings = "featured_listings"
        case displayListings = "display_listings"
        case reviews, sections
        case structuredPolicies = "structured_policies"
        case reviewVideosCount = "review_videos_count"
        case faq
        case listingCards = "listing_cards"
        case goToCartNudger = "go_to_cart_nudger"
        case bestSellers = "best_sellers"
        case favoriteShopsCount = "favorite_shops_count"
        case promotionBanner = "promotion_banner"
        case signals
        case returnPolicies = "return_policies"
        case listingSortOrder = "listing_sort_order"
        case banners
        case listingCount = "listing_count"
        case feedPaginationKey = "feed_pagination_key"
        case memberData = "member_data"
    }
}

// MARK: - FAQ
struct FAQ: Codable {
    let faqID, createDate, updateDate: Int
    let language: Language
    let question, answer, createDateFormatted, updateDateFormatted: String

    enum CodingKeys: String, CodingKey {
        case faqID = "faq_id"
        case createDate = "create_date"
        case updateDate = "update_date"
        case language, question, answer
        case createDateFormatted = "create_date_formatted"
        case updateDateFormatted = "update_date_formatted"
    }
}

enum Language: String, Codable {
    case en = "en"
}

// MARK: - FavoriteShopsCount
struct FavoriteShopsCount: Codable {
    let count: Int
}

// MARK: - MemberData
struct MemberData: Codable {
    let isFavorer, isSubscribedToVacationNotification: Bool
    let favoriteshopsCount: Int

    enum CodingKeys: String, CodingKey {
        case isFavorer = "is_favorer"
        case isSubscribedToVacationNotification = "is_subscribed_to_vacation_notification"
        case favoriteshopsCount = "favoriteshops_count"
    }
}

// MARK: - Policies
struct Policies: Codable {
    let welcome: JSONNull?
    let payment, shipping, refunds, additional: String
    let sellerInfo: String
    let hasNoPolicies: Bool
    let updateDate: JSONNull?
    let includeDisputeFormLink, canIncludeDisputeFormLink: Bool
    let privacy: String

    enum CodingKeys: String, CodingKey {
        case welcome, payment, shipping, refunds, additional
        case sellerInfo = "seller_info"
        case hasNoPolicies = "has_no_policies"
        case updateDate = "update_date"
        case includeDisputeFormLink = "include_dispute_form_link"
        case canIncludeDisputeFormLink = "can_include_dispute_form_link"
        case privacy
    }
}

// MARK: - ReturnPolicies
struct ReturnPolicies: Codable {
    let title, description: String
}

// MARK: - Reviews
struct Reviews: Codable {
    let reviews: [ReviewsReview]
    let count: Int
    let appreciationMedia: [AppreciationMedia]
    let appreciationMediaType: String

    enum CodingKeys: String, CodingKey {
        case reviews, count
        case appreciationMedia = "appreciation_media"
        case appreciationMediaType = "appreciation_media_type"
    }
}

// MARK: - AppreciationMedia
struct AppreciationMedia: Codable {
    let appreciationPhoto: AppreciationPhoto?
    let appreciationVideo: AppreciationVideo?

    enum CodingKeys: String, CodingKey {
        case appreciationPhoto = "appreciation_photo"
        case appreciationVideo = "appreciation_video"
    }
}

// MARK: - AppreciationPhoto
struct AppreciationPhoto: Codable {
    let transactionID: Int
    let reviewText: String
    let reviewRating: Int
    let buyerAvatarURL: String
    let buyerName: String
    let buyerProfileURL: String
    let buyerIsActive: Bool
    let createDate: Int
    let listingOnly: Bool
    let listingID: Int
    let listingTitle, listingImages, listingImageKeys, listingImageURL: JSONNull?
    let reviewTranslated: JSONNull?
    let language: Language
    let image: Icon

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case reviewText = "review_text"
        case reviewRating = "review_rating"
        case buyerAvatarURL = "buyer_avatar_url"
        case buyerName = "buyer_name"
        case buyerProfileURL = "buyer_profile_url"
        case buyerIsActive = "buyer_is_active"
        case createDate = "create_date"
        case listingOnly = "listing_only"
        case listingID = "listing_id"
        case listingTitle = "listing_title"
        case listingImages = "listing_images"
        case listingImageKeys = "listing_image_keys"
        case listingImageURL = "listing_image_url"
        case reviewTranslated = "review_translated"
        case language, image
    }
}

// MARK: - Icon
struct Icon: Codable {
    let key: String
    let url: String
    let sources: [IconSource]
    let imageID: Int?

    enum CodingKeys: String, CodingKey {
        case key, url, sources
        case imageID = "image_id"
    }
}

// MARK: - IconSource
struct IconSource: Codable {
    let width, height: Int
    let url: String
}

// MARK: - AppreciationVideo
struct AppreciationVideo: Codable {
    let transactionID, listingID: Int
    let listingTitle, listingImageURL: JSONNull?
    let reviewRating: Int
    let reviewText: String
    let reviewTranslated: JSONNull?
    let buyerName: String
    let buyerIsActive: Bool
    let createDate: Int
    let language: Language
    let video: AppreciationVideoVideo

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case listingID = "listing_id"
        case listingTitle = "listing_title"
        case listingImageURL = "listing_image_url"
        case reviewRating = "review_rating"
        case reviewText = "review_text"
        case reviewTranslated = "review_translated"
        case buyerName = "buyer_name"
        case buyerIsActive = "buyer_is_active"
        case createDate = "create_date"
        case language, video
    }
}

// MARK: - AppreciationVideoVideo
struct AppreciationVideoVideo: Codable {
    let url: String
    let posterURL, thumbnailURL: String
    let sources: [ListingCardSourceElement]
    let captions: JSONNull?
    let width, height: Int
    let duration, createDate: JSONNull?

    enum CodingKeys: String, CodingKey {
        case url
        case posterURL = "poster_url"
        case thumbnailURL = "thumbnail_url"
        case sources, captions, width, height, duration
        case createDate = "create_date"
    }
}

// MARK: - ListingCardSourceElement
struct ListingCardSourceElement: Codable {
    let format, type: String
    let url: String
}

// MARK: - ReviewsReview
struct ReviewsReview: Codable {
    let receiptID, date, buyerUserID: Int
    let buyerRealName, buyerLoginName: String
    let buyerAvatarURL: String
    let buyerAvatarImageKey: BuyerAvatarImageKey
    let buyerIsAnonymous: Bool
    let buyerRealNameOrLoginName, buyerCasualNameOrLoginName: String
    let buyerIsActive, buyerIsGuest, buyerIsNameWithheld: Bool
    let reviews: [ReviewReview]

    enum CodingKeys: String, CodingKey {
        case receiptID = "receipt_id"
        case date
        case buyerUserID = "buyer_user_id"
        case buyerRealName = "buyer_real_name"
        case buyerLoginName = "buyer_login_name"
        case buyerAvatarURL = "buyer_avatar_url"
        case buyerAvatarImageKey = "buyer_avatar_image_key"
        case buyerIsAnonymous = "buyer_is_anonymous"
        case buyerRealNameOrLoginName = "buyer_real_name_or_login_name"
        case buyerCasualNameOrLoginName = "buyer_casual_name_or_login_name"
        case buyerIsActive = "buyer_is_active"
        case buyerIsGuest = "buyer_is_guest"
        case buyerIsNameWithheld = "buyer_is_name_withheld"
        case reviews
    }
}

// MARK: - BuyerAvatarImageKey
struct BuyerAvatarImageKey: Codable {
    let imageType: String
    let imageID, ownerID, storage, version: Int
    let secret, buyerAvatarImageKeyExtension: String?
    let fullWidth, fullHeight: String
    let color, blurHash, hue, saturation: JSONNull?
    let height, width: Int?

    enum CodingKeys: String, CodingKey {
        case imageType = "image_type"
        case imageID = "image_id"
        case ownerID = "owner_id"
        case storage, version, secret
        case buyerAvatarImageKeyExtension = "extension"
        case fullWidth = "full_width"
        case fullHeight = "full_height"
        case color
        case blurHash = "blur_hash"
        case hue, saturation, height, width
    }
}

// MARK: - ReviewReview
struct ReviewReview: Codable {
    let transactionID, listingID: Int
    let listingTitle: String
    let listingImageURL: String
    let listingImage: ListingImage
    let review: String
    let rating: Int
    let response: JSONNull?
    let isResponseDeleted: Bool
    let language: Language
    let listing: Listing
    let updateDate: Int
    let isListingDisplayable, sellerLeftFeedback, buyerLeftFeedback: Bool
    let reviewTranslated: JSONNull?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case listingID = "listing_id"
        case listingTitle = "listing_title"
        case listingImageURL = "listing_image_url"
        case listingImage = "listing_image"
        case review, rating, response
        case isResponseDeleted = "is_response_deleted"
        case language, listing
        case updateDate = "update_date"
        case isListingDisplayable = "is_listing_displayable"
        case sellerLeftFeedback = "seller_left_feedback"
        case buyerLeftFeedback = "buyer_left_feedback"
        case reviewTranslated = "review_translated"
    }
}

// MARK: - Listing
struct Listing: Codable {
    let listingID, shopID: Int
    let shopName: String
    let shopURL: String
    let title: String
    let hasVariations, hasColorVariations, isSoldOut: Bool
    let price: String
    let quantity: Int
    let currencyCode: String
    let url: String
    let state: Int
    let isDownload, forPublicConsumption: Bool
    let createDate: Int
    let acceptsGiftCard: Bool
    let logging: Logging
    let image, image170: String
    let img: ListingImage
    let listingImages: [ListingImage]
    let promotions: [JSONAny]
    let priceFormatted, priceFormattedShort: String
    let priceInt: Int
    let priceUnformatted, currencySymbol: String
    let freeShippingCountries: [JSONAny]
    let isMachineTranslated, isBestseller, isBestsellerByFixedQtyCategoryLeaf, isBestsellerByFixedQtyCategoryL3: Bool
    let isScarce, isHandmade, isCustomizable, isPersonalizable: Bool
    let hasVariationsWithPricing: Bool
    let lastSaleDate: Int
    let isVintage, isUnique, isInMerchLibrary: Bool
    let shopAverageRating, shopTotalRatingCount: String
    let originCountryID: Int
    let usePrettyPricing: Bool
    let countrySpecificPricing, lowestPurchasablePrice: CountrySpecificPricing
    let minProcessingDays, maxProcessingDays: Int
    let originPostalCode: String
    let transitDetailsCalculated: TransitDetailsCalculated
    let isBuyerPromiseEligible: Bool
    let sellerTaxonomyID: Int
    let styleAttributes: [JSONAny]
    let isSurfaceable, forPatternConsumption, isVacation, isPattern: Bool
    let isRetail: Bool
    let freeShippingData: [String: Bool?]
    let signalPeckingOrder: [JSONAny]
    let hasManuallyAdjustedThumbnail, isListingImageLandscape, isTopRated: Bool
    let inCartCount, originalCreateDate: Int
    let shipsToRegions: [String]
    let videoKey: String?
    let video: ListingVideo?
    let hasStarSellerSignal: Bool
    let suppressionRestrictions: [String]
    let canBeWaitlisted, isPrivate: Bool
    let numColorVariations, numSizeVariations: Int
    let shouldShowBuyItNowButton, isMadeToOrder, areReturnsAccepted, areExchangesAccepted: Bool
    let returnDeadlineInDays: Int

    enum CodingKeys: String, CodingKey {
        case listingID = "listing_id"
        case shopID = "shop_id"
        case shopName = "shop_name"
        case shopURL = "shop_url"
        case title
        case hasVariations = "has_variations"
        case hasColorVariations = "has_color_variations"
        case isSoldOut = "is_sold_out"
        case price, quantity
        case currencyCode = "currency_code"
        case url, state
        case isDownload = "is_download"
        case forPublicConsumption = "for_public_consumption"
        case createDate = "create_date"
        case acceptsGiftCard = "accepts_gift_card"
        case logging, image, image170, img
        case listingImages = "listing_images"
        case promotions
        case priceFormatted = "price_formatted"
        case priceFormattedShort = "price_formatted_short"
        case priceInt = "price_int"
        case priceUnformatted = "price_unformatted"
        case currencySymbol = "currency_symbol"
        case freeShippingCountries = "free_shipping_countries"
        case isMachineTranslated = "is_machine_translated"
        case isBestseller = "is_bestseller"
        case isBestsellerByFixedQtyCategoryLeaf = "is_bestseller_by_fixed_qty_category_leaf"
        case isBestsellerByFixedQtyCategoryL3 = "is_bestseller_by_fixed_qty_category_l3"
        case isScarce = "is_scarce"
        case isHandmade = "is_handmade"
        case isCustomizable = "is_customizable"
        case isPersonalizable = "is_personalizable"
        case hasVariationsWithPricing = "has_variations_with_pricing"
        case lastSaleDate = "last_sale_date"
        case isVintage = "is_vintage"
        case isUnique = "is_unique"
        case isInMerchLibrary = "is_in_merch_library"
        case shopAverageRating = "shop_average_rating"
        case shopTotalRatingCount = "shop_total_rating_count"
        case originCountryID = "origin_country_id"
        case usePrettyPricing = "use_pretty_pricing"
        case countrySpecificPricing = "country_specific_pricing"
        case lowestPurchasablePrice = "lowest_purchasable_price"
        case minProcessingDays = "min_processing_days"
        case maxProcessingDays = "max_processing_days"
        case originPostalCode = "origin_postal_code"
        case transitDetailsCalculated = "transit_details_calculated"
        case isBuyerPromiseEligible = "is_buyer_promise_eligible"
        case sellerTaxonomyID = "seller_taxonomy_id"
        case styleAttributes = "style_attributes"
        case isSurfaceable = "is_surfaceable"
        case forPatternConsumption = "for_pattern_consumption"
        case isVacation = "is_vacation"
        case isPattern = "is_pattern"
        case isRetail = "is_retail"
        case freeShippingData = "free_shipping_data"
        case signalPeckingOrder = "signal_pecking_order"
        case hasManuallyAdjustedThumbnail = "has_manually_adjusted_thumbnail"
        case isListingImageLandscape = "is_listing_image_landscape"
        case isTopRated = "is_top_rated"
        case inCartCount = "in_cart_count"
        case originalCreateDate = "original_create_date"
        case shipsToRegions = "ships_to_regions"
        case videoKey = "video_key"
        case video
        case hasStarSellerSignal = "has_star_seller_signal"
        case suppressionRestrictions = "suppression_restrictions"
        case canBeWaitlisted = "can_be_waitlisted"
        case isPrivate = "is_private"
        case numColorVariations = "num_color_variations"
        case numSizeVariations = "num_size_variations"
        case shouldShowBuyItNowButton = "should_show_buy_it_now_button"
        case isMadeToOrder = "is_made_to_order"
        case areReturnsAccepted = "are_returns_accepted"
        case areExchangesAccepted = "are_exchanges_accepted"
        case returnDeadlineInDays = "return_deadline_in_days"
    }
}

// MARK: - CountrySpecificPricing
struct CountrySpecificPricing: Codable {
    let ew: Int
    let xd, xc, us: JSONNull?

    enum CodingKeys: String, CodingKey {
        case ew = "EW"
        case xd = "XD"
        case xc = "XC"
        case us = "US"
    }
}

// MARK: - ListingImage
struct ListingImage: Codable {
    let imageID, ownerID: Int
    let url, url75X75, url170X135, url224XN: String
    let url300X300, url340X270, url680X540, url570XN: String
    let url600X600: String
    let volume, version: Int
    let extraData, listingImageExtension, color, blurHash: String
    let hue, saturation, height, width: Int
    let altText: JSONNull?

    enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
        case ownerID = "owner_id"
        case url
        case url75X75 = "url_75x75"
        case url170X135 = "url_170x135"
        case url224XN = "url_224xN"
        case url300X300 = "url_300x300"
        case url340X270 = "url_340x270"
        case url680X540 = "url_680x540"
        case url570XN = "url_570xN"
        case url600X600 = "url_600x600"
        case volume, version
        case extraData = "extra_data"
        case listingImageExtension = "extension"
        case color
        case blurHash = "blur_hash"
        case hue, saturation, height, width
        case altText = "alt_text"
    }
}

// MARK: - Logging
struct Logging: Codable {
    let sellerCurrency, sellerCurrencyPrice: String
    let sellerCurrencyPriceInt: Int

    enum CodingKeys: String, CodingKey {
        case sellerCurrency = "seller_currency"
        case sellerCurrencyPrice = "seller_currency_price"
        case sellerCurrencyPriceInt = "seller_currency_price_int"
    }
}

// MARK: - TransitDetailsCalculated
struct TransitDetailsCalculated: Codable {
    let domesticCarrierID: Int
    let domesticMailClass: String
    let internationalCarrierID: Int
    let internationalMailClass: String
    let usInternationalMailClass: JSONNull?

    enum CodingKeys: String, CodingKey {
        case domesticCarrierID = "domestic_carrier_id"
        case domesticMailClass = "domestic_mail_class"
        case internationalCarrierID = "international_carrier_id"
        case internationalMailClass = "international_mail_class"
        case usInternationalMailClass = "us_international_mail_class"
    }
}

// MARK: - ListingVideo
struct ListingVideo: Codable {
    let url: String
    let thumbnailURL, posterURL: String
    let sources: [ListingCardSourceElement]
    let croppedSources: [JSONAny]
    let listingCardSources: [ListingCardSourceElement]
    let width, height: Int

    enum CodingKeys: String, CodingKey {
        case url
        case thumbnailURL = "thumbnail_url"
        case posterURL = "poster_url"
        case sources
        case croppedSources = "cropped_sources"
        case listingCardSources = "listing_card_sources"
        case width, height
    }
}

// MARK: - Shop
struct Shop: Codable {
    let shopID, userID: Int
    let shopName: String
    let url: String
    let policySellerInfo: String
    let createDate, updateDate, digitalListingCount: Int
    let digitalDeliveryListingCount: String
    let policyHasPrivateReceiptInfo, isShopLocationInGermany, isOpen: Bool
    let sellerAvatar: String
    let sellerName: String
    let soldCount: Int
    let soldCountAbbr: String
    let shopURL: String
    let owner: Owner
    let additionalCustomization: Bool
    let activeListingCount: Int
    let status: String
    let statusDate, lat, lon: Int
    let city, region, name, headline: String
    let message: String
    let messageUpdateDate: Int
    let messageToBuyers: String
    let openDate, favoritesCount, isVacation: Int
    let isSuspendedPaymentsMandate: Bool
    let brandingOption: Int
    let hasOnboardedStructuredPolicies, isUsingStructuredPolicies: Bool
    let facebookVerificationKey: String
    let traderDistinction: Int
    let forPublicConsumption, soldHidden: Bool
    let bannerURL: String
    let modules: [String]
    let hasAbout, hasAboutPage: Bool
    let averageRatingSchema, averageRating: Double
    let totalRatingCount, averageRatingCount, importedRatingCount: Int
    let storyHeadline, storyLeadingParagraph, story: String
    let pullQuote: JSONNull?
    let relatedLinks, location: String
    let geonameID: Int
    let shopLanguages: [ShopLanguage]
    let countryCode, currencyCode: String
    let hasCurrencyCode, hasLanguagePreferences: Bool
    let primaryLanguageID: Int
    let hasIcon: Bool
    let icon: Icon
    let hasBanner, hasLargeBanner: Bool
    let largeBanner: Icon
    let acceptsDirectCheckout, acceptsGiftCard, acceptsMoneyOrders, acceptsChecks: Bool
    let acceptsOther, acceptsPaypal, acceptsBankTransfers, acceptsCustomRequests: Bool
    let buyerPromiseEnabled, hasRepricedListingsViaBuyerPromiseEnabler, rearrangeEnabled, hasOwners: Bool
    let aboutInfoExists: Bool
    let googleAnalyticsPropertyID, onboardingStatus, vacationMessage: String
    let vacationMessageUpdateDate: Int
    let vacationAutoreply, totalShareCount: String
    let hasPublishedStructuredRefundsPolicy, isBusiness, hasBadge, isTestAccount: Bool
    let isTrader: Bool
    let shipsToCountryIDS: [JSONAny]
    let colorTint: JSONNull?
    let isDarkMode: Bool

    enum CodingKeys: String, CodingKey {
        case shopID = "shop_id"
        case userID = "user_id"
        case shopName = "shop_name"
        case url
        case policySellerInfo = "policy_seller_info"
        case createDate = "create_date"
        case updateDate = "update_date"
        case digitalListingCount = "digital_listing_count"
        case digitalDeliveryListingCount = "digital_delivery_listing_count"
        case policyHasPrivateReceiptInfo = "policy_has_private_receipt_info"
        case isShopLocationInGermany = "is_shop_location_in_germany"
        case isOpen = "is_open"
        case sellerAvatar = "seller_avatar"
        case sellerName = "seller_name"
        case soldCount = "sold_count"
        case soldCountAbbr = "sold_count_abbr"
        case shopURL = "shop_url"
        case owner
        case additionalCustomization = "additional_customization"
        case activeListingCount = "active_listing_count"
        case status
        case statusDate = "status_date"
        case lat, lon, city, region, name, headline, message
        case messageUpdateDate = "message_update_date"
        case messageToBuyers = "message_to_buyers"
        case openDate = "open_date"
        case favoritesCount = "favorites_count"
        case isVacation = "is_vacation"
        case isSuspendedPaymentsMandate = "is_suspended_payments_mandate"
        case brandingOption = "branding_option"
        case hasOnboardedStructuredPolicies = "has_onboarded_structured_policies"
        case isUsingStructuredPolicies = "is_using_structured_policies"
        case facebookVerificationKey = "facebook_verification_key"
        case traderDistinction = "trader_distinction"
        case forPublicConsumption = "for_public_consumption"
        case soldHidden = "sold_hidden"
        case bannerURL = "banner_url"
        case modules
        case hasAbout = "has_about"
        case hasAboutPage = "has_about_page"
        case averageRatingSchema = "average_rating_schema"
        case averageRating = "average_rating"
        case totalRatingCount = "total_rating_count"
        case averageRatingCount = "average_rating_count"
        case importedRatingCount = "imported_rating_count"
        case storyHeadline = "story_headline"
        case storyLeadingParagraph = "story_leading_paragraph"
        case story
        case pullQuote = "pull_quote"
        case relatedLinks = "related_links"
        case location
        case geonameID = "geoname_id"
        case shopLanguages = "shop_languages"
        case countryCode = "country_code"
        case currencyCode = "currency_code"
        case hasCurrencyCode = "has_currency_code"
        case hasLanguagePreferences = "has_language_preferences"
        case primaryLanguageID = "primary_language_id"
        case hasIcon = "has_icon"
        case icon
        case hasBanner = "has_banner"
        case hasLargeBanner = "has_large_banner"
        case largeBanner = "large_banner"
        case acceptsDirectCheckout = "accepts_direct_checkout"
        case acceptsGiftCard = "accepts_gift_card"
        case acceptsMoneyOrders = "accepts_money_orders"
        case acceptsChecks = "accepts_checks"
        case acceptsOther = "accepts_other"
        case acceptsPaypal = "accepts_paypal"
        case acceptsBankTransfers = "accepts_bank_transfers"
        case acceptsCustomRequests = "accepts_custom_requests"
        case buyerPromiseEnabled = "buyer_promise_enabled"
        case hasRepricedListingsViaBuyerPromiseEnabler = "has_repriced_listings_via_buyer_promise_enabler"
        case rearrangeEnabled = "rearrange_enabled"
        case hasOwners = "has_owners"
        case aboutInfoExists = "about_info_exists"
        case googleAnalyticsPropertyID = "google_analytics_property_id"
        case onboardingStatus = "onboarding_status"
        case vacationMessage = "vacation_message"
        case vacationMessageUpdateDate = "vacation_message_update_date"
        case vacationAutoreply = "vacation_autoreply"
        case totalShareCount = "total_share_count"
        case hasPublishedStructuredRefundsPolicy = "has_published_structured_refunds_policy"
        case isBusiness = "is_business"
        case hasBadge = "has_badge"
        case isTestAccount = "is_test_account"
        case isTrader = "is_trader"
        case shipsToCountryIDS = "ships_to_country_ids"
        case colorTint = "color_tint"
        case isDarkMode = "is_dark_mode"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let userID: Int
    let loginName: String
    let isSeller: Bool
    let createDate, updateDate: Int
    let avatarURL: String
    let hasAvatar: Bool
    let followerCount, followingCount: Int
    let displayName, realName: String
    let favoriteItemsPublic, favoriteShopsPublic, favoriteTreasuriesPublic, hasPage: Bool
    let avatar: Icon
    let numFavorites: Int
    let bio, gender, firstName, lastName: String
    let location: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case loginName = "login_name"
        case isSeller = "is_seller"
        case createDate = "create_date"
        case updateDate = "update_date"
        case avatarURL = "avatar_url"
        case hasAvatar = "has_avatar"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case displayName = "display_name"
        case realName = "real_name"
        case favoriteItemsPublic = "favorite_items_public"
        case favoriteShopsPublic = "favorite_shops_public"
        case favoriteTreasuriesPublic = "favorite_treasuries_public"
        case hasPage = "has_page"
        case avatar
        case numFavorites = "num_favorites"
        case bio, gender
        case firstName = "first_name"
        case lastName = "last_name"
        case location
    }
}

// MARK: - ShopLanguage
struct ShopLanguage: Codable {
    let id: Int
    let code, language: String
    let isMachineLanguage: Int
    let machineCode: String
    let machineID, langID: Int
    let langCode, name: String

    enum CodingKeys: String, CodingKey {
        case id, code, language
        case isMachineLanguage = "is_machine_language"
        case machineCode = "machine_code"
        case machineID = "machine_id"
        case langID = "lang_id"
        case langCode = "lang_code"
        case name
    }
}

// MARK: - ShopAbout
struct ShopAbout: Codable {
    let storyHeadline, story: String
    let url: String
    let images, videos: [JSONAny]
    let relatedLinks: [RelatedLink]
    let members: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case storyHeadline = "story_headline"
        case story, url, images, videos
        case relatedLinks = "related_links"
        case members
    }
}

// MARK: - RelatedLink
struct RelatedLink: Codable {
    let title: String
    let url: String
}

// MARK: - Signals
struct Signals: Codable {
    let shopReliability, shopBuyAgain: JSONNull?

    enum CodingKeys: String, CodingKey {
        case shopReliability = "shop_reliability"
        case shopBuyAgain = "shop_buy_again"
    }
}

// MARK: - StructuredPolicies
struct StructuredPolicies: Codable {
    let createDate, structuredPoliciesID, updateDate: Int
    let createDateFormatted, updateDateFormatted: String
    let hasUnstructuredPolicies: Bool
    let additionalTermsAndConditions: JSONNull?
    let privacy: Privacy
    let shipping: Shipping
    let payments: Payments
    let refunds: Refunds
    let shopInGermany, includeDisputeFormLink, canHaveAdditionalPolicies: Bool

    enum CodingKeys: String, CodingKey {
        case createDate = "create_date"
        case structuredPoliciesID = "structured_policies_id"
        case updateDate = "update_date"
        case createDateFormatted = "create_date_formatted"
        case updateDateFormatted = "update_date_formatted"
        case hasUnstructuredPolicies = "has_unstructured_policies"
        case additionalTermsAndConditions = "additional_terms_and_conditions"
        case privacy, shipping, payments, refunds
        case shopInGermany = "shop_in_germany"
        case includeDisputeFormLink = "include_dispute_form_link"
        case canHaveAdditionalPolicies = "can_have_additional_policies"
    }
}

// MARK: - Payments
struct Payments: Codable {
    let acceptedPaymentMethods: [String]
    let acceptsDirectCheckout: Bool
    let protectedPaymentMethods: [String]
    let manualPaymentMethods: [JSONAny]
    let acceptsPaypal, acceptsIndianPaymentMethods: Bool

    enum CodingKeys: String, CodingKey {
        case acceptedPaymentMethods = "accepted_payment_methods"
        case acceptsDirectCheckout = "accepts_direct_checkout"
        case protectedPaymentMethods = "protected_payment_methods"
        case manualPaymentMethods = "manual_payment_methods"
        case acceptsPaypal = "accepts_paypal"
        case acceptsIndianPaymentMethods = "accepts_indian_payment_methods"
    }
}

// MARK: - Privacy
struct Privacy: Codable {
    let flags: Flags
    let flagsOrdered: [FlagsOrdered]
    let header: String
    let order: [String]

    enum CodingKeys: String, CodingKey {
        case flags
        case flagsOrdered = "flags_ordered"
        case header, order
    }
}

// MARK: - Flags
struct Flags: Codable {
    let other: Other
}

// MARK: - Other
struct Other: Codable {
    let enabled: Bool
    let label, language: String
}

// MARK: - FlagsOrdered
struct FlagsOrdered: Codable {
    let key: String
    let enabled: Bool
    let label, language: String
    let editable: Bool
}

// MARK: - Refunds
struct Refunds: Codable {
    let acceptedSummaryString, notAcceptedSummaryString: String
    let acceptsReturns, acceptsCancellations: Bool
    let contactSellerWithinDays, returnItemsWithinDays, cancelWithinHours: Int
    let cancellationWindowType: String
    let exchanges, buyerResponsibleForReturns, includeConditionsOfReturnText: Bool
    let nonRefundableItems: [NonRefundableItem]

    enum CodingKeys: String, CodingKey {
        case acceptedSummaryString = "accepted_summary_string"
        case notAcceptedSummaryString = "not_accepted_summary_string"
        case acceptsReturns = "accepts_returns"
        case acceptsCancellations = "accepts_cancellations"
        case contactSellerWithinDays = "contact_seller_within_days"
        case returnItemsWithinDays = "return_items_within_days"
        case cancelWithinHours = "cancel_within_hours"
        case cancellationWindowType = "cancellation_window_type"
        case exchanges
        case buyerResponsibleForReturns = "buyer_responsible_for_returns"
        case includeConditionsOfReturnText = "include_conditions_of_return_text"
        case nonRefundableItems = "non_refundable_items"
    }
}

// MARK: - NonRefundableItem
struct NonRefundableItem: Codable {
    let type, name: String
    let nonRefundable: Bool

    enum CodingKeys: String, CodingKey {
        case type, name
        case nonRefundable = "non_refundable"
    }
}

// MARK: - Shipping
struct Shipping: Codable {
    let hasShippingUpgrades, shipsInternational: Bool
    let processingTimeText: String
    let estimates: [Estimate]
    let processingDaysPerWeek: Int

    enum CodingKeys: String, CodingKey {
        case hasShippingUpgrades = "has_shipping_upgrades"
        case shipsInternational = "ships_international"
        case processingTimeText = "processing_time_text"
        case estimates
        case processingDaysPerWeek = "processing_days_per_week"
    }
}

// MARK: - Estimate
struct Estimate: Codable {
    let regionCode, region, type, displayName: String

    enum CodingKeys: String, CodingKey {
        case regionCode = "region_code"
        case region, type
        case displayName = "display_name"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}
