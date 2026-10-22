import Foundation

enum SampleDestinations {
    static let all: [DestinationDTO] = [
        DestinationDTO(
            id: "dest-001", name: "Roma", country: "Italia", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800&q=80",
            activityCount: 119, travelerCount: 10652888, reviewCount: 284467, rating: 8.9,
            description: "Roma, la Ciudad Eterna, combina iconos del Imperio Romano con fuentes barrocas y barrios tradicionales. El Coliseo, el Foro Romano, el Panteón y los Museos Vaticanos son solo algunas de sus joyas. Perderse por sus calles es descubrir más de 2.500 años de historia."
        ),
        DestinationDTO(
            id: "dest-002", name: "París", country: "Francia", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80",
            activityCount: 127, travelerCount: 4382026, reviewCount: 183731, rating: 8.9,
            description: "París, la Ciudad de la Luz, es sinónimo de romance, arte y cultura. La Torre Eiffel, el Louvre, Notre-Dame, Montmartre y los Campos Elíseos forman parte del imaginario colectivo mundial. Una ciudad donde cada rincón es una obra de arte."
        ),
        DestinationDTO(
            id: "dest-003", name: "Madrid", country: "España", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800&q=80",
            activityCount: 148, travelerCount: 2792478, reviewCount: 141689, rating: 9.1,
            description: "Madrid, la capital española, combina modernidad y tradición. El Museo del Prado, el Thyssen, el Reina Sofía, el Parque del Retiro y la vibrante vida nocturna hacen de esta ciudad un destino único y apasionante."
        ),
        DestinationDTO(
            id: "dest-004", name: "Barcelona", country: "España", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1562883676-8c7feb83f09b?w=800&q=80",
            activityCount: 142, travelerCount: 3100000, reviewCount: 198000, rating: 9.0,
            description: "Barcelona, la Ciudad Condal, deslumbra con la arquitectura modernista de Gaudí, sus playas mediterráneas y su animada vida cultural. La Sagrada Família, el Parque Güell, el Barrio Gótico y el Mercado de la Boqueria son paradas obligadas."
        ),
        DestinationDTO(
            id: "dest-005", name: "Londres", country: "Reino Unido", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&q=80",
            activityCount: 125, travelerCount: 2734307, reviewCount: 127358, rating: 9.1,
            description: "Londres combina historia milenaria con modernidad cosmopolita. El Tower Bridge, Buckingham Palace, el British Museum, el Big Ben y los barrios de Notting Hill o Shoreditch hacen de la capital británica un destino inagotable."
        ),
        DestinationDTO(
            id: "dest-006", name: "Ámsterdam", country: "Países Bajos", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1534351590666-13e3e96b5017?w=800&q=80",
            activityCount: 118, travelerCount: 1890000, reviewCount: 98000, rating: 9.0,
            description: "Ámsterdam, con sus canales y casas inclinadas del siglo XVII, es una de las ciudades más pintorescas de Europa. El Rijksmuseum, la Casa de Ana Frank y los molinos de los alrededores son imprescindibles en la capital neerlandesa."
        ),
        DestinationDTO(
            id: "dest-007", name: "Budapest", country: "Hungría", continent: "Europa",
            imageURL: "https://images.unsplash.com/photo-1565426873118-a17ed65d74b9?w=800&q=80",
            activityCount: 95, travelerCount: 1456000, reviewCount: 78000, rating: 9.0,
            description: "Budapest, la joya del Danubio, sorprende con su arquitectura espléndida a orillas del río. El Palacio de Buda, el Parlamento, los Baños Széchenyi y los mercados de la ciudad hacen de Budapest uno de los destinos más fotogénicos de Europa."
        ),
        DestinationDTO(
            id: "dest-008", name: "Tokio", country: "Japón", continent: "Asia",
            imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80",
            activityCount: 87, travelerCount: 980000, reviewCount: 45000, rating: 9.2,
            description: "Tokio mezcla lo ultramoderno con tradiciones milenarias. Los templos de Asakusa, los jardines imperiales, la gastronomía excepcional, los barrios de anime de Akihabara y los neones de Shinjuku hacen de la capital japonesa un viaje a otro mundo."
        )
    ]
}
