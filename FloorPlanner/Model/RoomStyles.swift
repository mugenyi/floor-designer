enum RoomStyle: String, CaseIterable {
    case custom
    // 🌿 Popular & Modern Styles
    case modern, contemporary, minimalist, scandinavian, midCenturyModern, industrial, bohemian, japandi
    
    // 🏛 Classic & Timeless Styles
    case traditional, transitional, artDeco, classicEuropean, colonial, victorian, frenchCountry, mediterranean
    
    // 🏡 Casual & Cozy Styles
    case rustic, farmhouse, cottagecore, coastal, countryChic, shabbyChic
    
    // 🎨 Luxury & Statement Styles
    case glam, eclectic, maximalist, urbanModern, retro, futuristic
    
    // 🕌 Cultural & Global Styles
    case moroccan, japaneseZen, chineseTraditional, indianEthnic, africanTribal, tropical
    
    // 🌙 Mood-Based Styles
    case cozy, darkAcademia, lightAndAiry, natureInspired, minimalLuxury
}

extension RoomStyle {
    /// Base description focusing only on *style* elements
    var baseDescription: String {
        switch self {
        case .custom: return ""
        case .modern: return "with clean lines, open space, neutral colors, sleek furniture, and polished finishes"
        case .contemporary: return "with bold contrasts, smooth surfaces, minimalist furniture, and statement lighting"
        case .minimalist: return "with neutral walls, uncluttered furniture, simple lines, and open negative space"
        case .scandinavian: return "with bright white walls, natural wood, cozy textiles, simple furniture, and lots of natural light"
        case .midCenturyModern: return "with organic wooden furniture, retro shapes, bold accent colors, and large windows"
        case .industrial: return "with exposed brick walls, metal beams, concrete flooring, and leather furniture"
        case .bohemian: return "with layered rugs, colorful textiles, plants, eclectic furniture, and warm lighting"
        case .japandi: return "combining Japanese minimalism with Scandinavian coziness, natural wood, muted tones, and low-profile furniture"
            
        case .traditional: return "with ornate wood furniture, rich fabrics, patterned rugs, chandeliers, and symmetrical design"
        case .transitional: return "mixing modern furniture with classic accents, a soft color palette, and balanced proportions"
        case .artDeco: return "with geometric patterns, glossy surfaces, jewel tones, mirrors, and metallic accents"
        case .classicEuropean: return "with ornate molding, marble flooring, antique furniture, and luxurious fabrics"
        case .colonial: return "with dark wood furniture, traditional fabrics, and symmetrical layouts"
        case .victorian: return "with rich wallpaper, velvet drapes, carved wood furniture, and antique details"
        case .frenchCountry: return "with rustic wood beams, distressed cabinets, soft pastel tones, and vintage décor"
        case .mediterranean: return "with warm earthy tones, arched doorways, terracotta tiles, and rustic beams"
            
        case .rustic: return "with exposed wood beams, stone textures, natural materials, and earthy tones"
        case .farmhouse: return "with shiplap walls, wooden tables, vintage accents, and soft whites and beiges"
        case .cottagecore: return "with floral fabrics, lace curtains, wooden furniture, plants, and soft pastels"
        case .coastal: return "with whitewashed walls, wicker furniture, blue and white décor, and breezy windows"
        case .countryChic: return "with rustic wood, soft linens, pastel accents, and vintage touches"
        case .shabbyChic: return "with distressed white furniture, soft pink tones, antique décor, and cozy fabrics"
            
        case .glam: return "with velvet sofas, gold accents, crystal chandeliers, mirrors, and dramatic lighting"
        case .eclectic: return "with mismatched furniture, bold colors, patterned rugs, and mixed décor"
        case .maximalist: return "with bold wallpaper, vibrant colors, layered furniture, and abundant decoration"
        case .urbanModern: return "with sleek furniture, large windows, trendy décor, and open layouts"
        case .retro: return "with vintage furniture, colorful wallpaper, shag carpets, and geometric patterns"
        case .futuristic: return "with sleek white surfaces, LED lighting, curved furniture, and high-tech design"
            
        case .moroccan: return "with colorful mosaic tiles, carved wooden furniture, lanterns, and rich fabrics"
        case .japaneseZen: return "with tatami mats, sliding shoji screens, natural wood, minimal décor, and balance"
        case .chineseTraditional: return "with dark carved wood, bold red accents, symbolic décor, and lantern lighting"
        case .indianEthnic: return "with vibrant textiles, carved furniture, brass décor, and colorful patterns"
        case .africanTribal: return "with earthy tones, handmade crafts, woven rugs, and tribal artwork"
        case .tropical: return "with bamboo furniture, palm plants, open windows, light fabrics, and natural textures"
            
        case .cozy: return "with warm lighting, soft blankets, candles, and comfortable furniture"
        case .darkAcademia: return "with wooden shelves, vintage books, leather chairs, moody lighting, and dark tones"
        case .lightAndAiry: return "with white walls, minimal furniture, large windows, and natural sunlight"
        case .natureInspired: return "with indoor plants, natural stone, wood accents, and earthy textures"
        case .minimalLuxury: return "with clean lines, uncluttered space, high-end finishes, and elegant neutrals"
        }
    }
    
    /// Generate a full AI prompt with room type
    func prompt(for room: RoomType) -> String {
        return "A \(self.rawValue.capitalized) \(room.rawValue.replacingOccurrences(of: "Room", with: "").lowercased()) \(baseDescription)."
    }
   
    
    func samplePrompt () -> String {
        return "A \(self.rawValue.capitalized)  room  \(baseDescription)."
    }


        var localizedName: String {
            switch self {
            case .custom: return String(localized: "Custom")
            case .scandinavian: return String(localized: "Scandinavian")
            case .modern: return String(localized: "Modern")
            case .minimalist: return String(localized: "Minimalist")
            case .industrial: return String(localized: "Industrial")
            case .bohemian: return String(localized: "Bohemian")
            case .traditional: return String(localized: "Traditional")
            case .mediterranean: return String(localized: "Mediterranean")
            case .japaneseZen: return String(localized: "Japanese Zen")
            case .rustic: return String(localized: "Rustic")
            case .artDeco: return String(localized: "Art Deco")
            case .farmhouse: return String(localized: "Farmhouse")
            case .midCenturyModern: return String(localized: "Mid-Century Modern")
            case .coastal: return String(localized: "Coastal")
            case .futuristic: return String(localized: "Futuristic")
            case .contemporary: return String(localized: "contemporary")
            case .japandi: return String(localized: "Japandi")
            case .transitional:
                return String(localized: "Transitional")
            case .classicEuropean:
                return String(localized: "Classic European")
            case .colonial:
                return String(localized: "Colonial")
            case .victorian:
                return String(localized: "victorian")
            case .frenchCountry:
                return String(localized: "french Country")
            case .cottagecore:
                return String(localized: "Cottagecore")
            case .countryChic:
                return String(localized: "Country Chic")
            case .shabbyChic:
                return String(localized: "Shabby Chic")
            case .glam:
                return String(localized: "Glam")
            case .eclectic:
                return String(localized: "Eclectic")
            case .maximalist:
                return String(localized: "Maximalist")
            case .urbanModern:
                return String(localized: "Urban Modern")
            case .retro:
                return String(localized: "Retro")
            case .moroccan:
                return String(localized: "Moroccan")
            case .chineseTraditional:
                return String(localized: "Chinese Traditional")
            case .indianEthnic:
                return String(localized: "Indian Ethnic")
            case .africanTribal:
                return String(localized: "African Tribal")
            case .tropical:
                return String(localized: "Tropical")
            case .cozy:
                return String(localized: "Cozy")
            case .darkAcademia:
                return String(localized: "Dark Academia")
            case .lightAndAiry:
                return String(localized: "Light And Airy")
            case .natureInspired:
                return String(localized: "Nature Inspired")
            case .minimalLuxury:
                return String(localized: "Minimal Luxury")
            }
        }
    

}
