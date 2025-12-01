enum FloorTileDesigns: String, CaseIterable {
    case custom
    case image
    case marbleTile
    case porcelainMatte
    case ceramicGlossy
    case graniteTile
    case travertineTile
    case terrazzoTile
    case mosaicTile
    case woodLookTile
    case herringboneTile
    case chevronTile
    case subwayTile
    case moroccanTile
    case hexagonTile
    case cementTile
    case pebbleStoneTile
    case slateTile
    case quartzTile
    case onyxTile
    case encausticPatternTile
    case largeFormatTile
    
    var prompt: String {
        switch self {
        case .custom: return "custom"
        case .image: return "image"

        case .marbleTile:
            return "A luxurious marble tile floor with natural veining, glossy finish, soft white and grey patterns, and elegant stone texture."

        case .porcelainMatte:
            return "A modern porcelain matte tile floor with smooth texture, muted tones, and a clean, contemporary appearance."

        case .ceramicGlossy:
            return "A classic ceramic glossy tile floor with a shiny surface, clean lines, and reflective finish suitable for kitchens and bathrooms."

        case .graniteTile:
            return "A durable granite tile floor featuring natural grain textures, speckled patterns, and a strong stone appearance."

        case .travertineTile:
            return "An earthy travertine tile floor with warm colors, subtle pits, textured stone look, and a rustic Mediterranean feel."

        case .terrazzoTile:
            return "A stylish terrazzo tile floor with colorful stone, marble, and glass chips embedded in smooth polished concrete."

        case .mosaicTile:
            return "A mosaic tile floor made of small geometric pieces forming artistic patterns, vibrant colors, and decorative detail."

        case .woodLookTile:
            return "A realistic wood-look tile floor with natural grain patterns, warm tones, and the durability of tile with the beauty of wood."

        case .herringboneTile:
            return "A decorative herringbone tile floor arranged in a zig-zag pattern with refined, elegant tile placement."

        case .chevronTile:
            return "A modern chevron tile floor with angled tiles forming clean V-shaped lines for a stylish geometric look."

        case .subwayTile:
            return "A classic subway tile floor with rectangular tiles arranged in a brick pattern, clean and timeless."

        case .moroccanTile:
            return "A colorful Moroccan tile floor with intricate patterns, bold shapes, and traditional artistic designs."

        case .hexagonTile:
            return "A hexagon tile floor with six-sided geometric shapes, modern aesthetics, and smooth matte or glossy finishes."

        case .cementTile:
            return "An industrial cement tile floor with raw concrete texture, minimalist tones, and a contemporary urban feel."

        case .pebbleStoneTile:
            return "A natural pebble stone tile floor with smooth river stones embedded in grout, giving a spa-like organic texture."

        case .slateTile:
            return "A bold slate tile floor with dark tones, rugged textures, and natural variation across each stone tile."

        case .quartzTile:
            return "A premium quartz tile floor with polished finish, refined mineral patterns, and a clean modern surface."

        case .onyxTile:
            return "A dramatic onyx tile floor with translucent layers, rich contrasting colors, and a luxurious stone appearance."

        case .encausticPatternTile:
            return "A vintage patterned encaustic tile floor with bold prints, artistic motifs, and handcrafted charm."

        case .largeFormatTile:
            return "A large-format tile floor with oversized tiles, minimal grout lines, smooth texture, and a high-end modern look."
        }
    }

    
    var localizedName: String {
        switch self {
        case .marbleTile: return String(localized: "Marble Tile")
        case .porcelainMatte: return String(localized: "Porcelain Matte Tile")
        case .ceramicGlossy: return String(localized: "Ceramic Glossy Tile")
        case .graniteTile: return String(localized: "Granite Tile")
        case .travertineTile: return String(localized: "Travertine Tile")
        case .terrazzoTile: return String(localized: "Terrazzo Tile")
        case .mosaicTile: return String(localized: "Mosaic Tile")
        case .woodLookTile: return String(localized: "Wood-Look Tile")
        case .herringboneTile: return String(localized: "Herringbone Tile")
        case .chevronTile: return String(localized: "Chevron Tile")
        case .subwayTile: return String(localized: "Subway Tile")
        case .moroccanTile: return String(localized: "Moroccan Tile")
        case .hexagonTile: return String(localized: "Hexagon Tile")
        case .cementTile: return String(localized: "Cement Tile")
        case .pebbleStoneTile: return String(localized: "Pebble Stone Tile")
        case .slateTile: return String(localized: "Slate Tile")
        case .quartzTile: return String(localized: "Quartz Tile")
        case .onyxTile: return String(localized: "Onyx Tile")
        case .encausticPatternTile: return String(localized: "Encaustic Pattern Tile")
        case .largeFormatTile: return String(localized: "Large Format Tile")
        case .custom: return String(localized: "Custom")
        case .image: return String(localized: "Upload Image")
        }
    }

}
