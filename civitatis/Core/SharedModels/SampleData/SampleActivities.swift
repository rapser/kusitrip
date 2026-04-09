import Foundation

enum SampleActivities {
    static let all: [ActivityDTO] = [
        // ROME
        ActivityDTO(
            id: "act-001",
            title: "Tour por el Coliseo con acceso a la Arena + Foro y Palatino",
            descriptionText: "El Coliseo, el Foro y el Palatino son los grandes vestigios de la Roma Imperial. Lo descubriréis en este tour que incluye una visita por la Arena de gladiadores del Coliseo. Accederemos por la puerta de los gladiadores para pisar la Arena, el lugar exacto donde se celebraban los combates de gladiadores. Durante 30 minutos, el guía explicará la ingeniería romana y el funcionamiento de los ascensores que subían a las fieras desde el hipogeo.",
            price: 275.27,
            originalPrice: 316.40,
            rating: 9.3,
            reviewCount: 32777,
            travelerCount: 987101,
            categoryId: "guided",
            destinationId: "dest-001",
            imageURLs: [
                "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800&q=80",
                "https://images.unsplash.com/photo-1569000813441-65ef5abdc5a6?w=800&q=80",
                "https://images.unsplash.com/photo-1515542622106-78bda8ba0e5b?w=800&q=80"
            ],
            durationMinutes: 150,
            language: "Español",
            cancellationDays: 5,
            isFree: false,
            meetingPoint: "Estación de metro Colosseo (salida Via dei Fori Imperiali), Roma",
            includes: [
                "Guía en español",
                "Entrada a la Arena de gladiadores del Coliseo",
                "Acceso al Foro Romano y Monte Palatino",
                "Acceso a las gradas inferiores del Coliseo",
                "Descuento de hasta el 13% respecto a la reserva por separado"
            ]
        ),
        ActivityDTO(
            id: "act-002",
            title: "Visita guiada por los Museos Vaticanos y la Capilla Sixtina",
            descriptionText: "En esta visita guiada por los Museos Vaticanos y la Capilla Sixtina veremos una de las colecciones de arte más importantes del mundo. ¡Incluye entrada preferente! Contemplaremos los frescos de Miguel Ángel —incluida la famosa escena de La creación de Adán— y las galerías de tapices y mapas geográficos. La visita culmina con el acceso a la Basílica de San Pedro.",
            price: 269.95,
            originalPrice: 333.27,
            rating: 8.9,
            reviewCount: 56437,
            travelerCount: 2782925,
            categoryId: "guided",
            destinationId: "dest-001",
            imageURLs: [
                "https://images.unsplash.com/photo-1577083553180-732b7c9b4f54?w=800&q=80",
                "https://images.unsplash.com/photo-1491566102020-21838225c3c8?w=800&q=80"
            ],
            durationMinutes: 150,
            language: "Español",
            cancellationDays: 3,
            isFree: false,
            meetingPoint: "Piazza del Risorgimento, Roma (frente a los Museos Vaticanos)",
            includes: [
                "Guía en español",
                "Entrada preferente a los Museos Vaticanos",
                "Entrada a la Capilla Sixtina",
                "Descuento del 19% respecto al precio habitual"
            ]
        ),
        ActivityDTO(
            id: "act-003",
            title: "Free tour por Roma",
            descriptionText: "La ciudad de los césares, del Barroco y, por supuesto, la Ciudad Eterna. En nuestro free tour por Roma descubriremos la monumentalidad de la capital italiana. Visitaremos el Panteón de Agripa, la Fontana de Trevi, la Piazza Navona, el Campo de' Fiori y más lugares imprescindibles de la ciudad sin pagar entrada.",
            price: 0,
            originalPrice: nil,
            rating: 9.0,
            reviewCount: 45052,
            travelerCount: 2123753,
            categoryId: "free",
            destinationId: "dest-001",
            imageURLs: [
                "https://images.unsplash.com/photo-1515542622106-78bda8ba0e5b?w=800&q=80"
            ],
            durationMinutes: 120,
            language: "Español",
            cancellationDays: 0,
            isFree: true,
            meetingPoint: "Fuente de los Cuatro Ríos, Piazza Navona, Roma",
            includes: ["Guía en español voluntario"]
        ),
        // PARIS
        ActivityDTO(
            id: "act-004",
            title: "Visita guiada a la Torre Eiffel con acceso prioritario",
            descriptionText: "Sube a la Torre Eiffel con acceso prioritario y disfruta de las mejores vistas de París desde las alturas. Nuestro guía en español te contará todos los secretos de esta icónica estructura metálica: desde su construcción por Gustave Eiffel para la Exposición Universal de 1889 hasta su papel como símbolo romántico de Francia.",
            price: 189.90,
            originalPrice: 220.50,
            rating: 9.1,
            reviewCount: 28340,
            travelerCount: 1456000,
            categoryId: "guided",
            destinationId: "dest-002",
            imageURLs: [
                "https://images.unsplash.com/photo-1499856369571-a3a3b16b28b8?w=800&q=80",
                "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80"
            ],
            durationMinutes: 120,
            language: "Español",
            cancellationDays: 5,
            isFree: false,
            meetingPoint: "Bajo la Torre Eiffel, Champ de Mars, París",
            includes: [
                "Guía en español",
                "Acceso prioritario a la 2.ª planta",
                "Audioguía opcional"
            ]
        ),
        ActivityDTO(
            id: "act-005",
            title: "Paseo en barco por el Sena",
            descriptionText: "Dar un paseo en barco por el Sena es imprescindible para ver París desde una perspectiva única. La embarcación es panorámica y tiene parte descubierta para disfrutar de las mejores vistas de Notre-Dame, el Louvre, el Musée d'Orsay y la Torre Eiffel desde el agua.",
            price: 71.71,
            originalPrice: 80.15,
            rating: 8.1,
            reviewCount: 13082,
            travelerCount: 890000,
            categoryId: "boat",
            destinationId: "dest-002",
            imageURLs: [
                "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800&q=80"
            ],
            durationMinutes: 60,
            language: "Español",
            cancellationDays: 2,
            isFree: false,
            meetingPoint: "Pont de l'Alma, orilla derecha del Sena, París",
            includes: ["Crucero 1 hora", "Audioguía multilingüe"]
        ),
        // MADRID
        ActivityDTO(
            id: "act-006",
            title: "Tour por el Palacio Real de Madrid con entradas",
            descriptionText: "Visita el Palacio Real de Madrid, la residencia oficial de la Familia Real española y uno de los palacios más grandes de Europa. Con más de 3,400 habitaciones, el Palacio Real alberga impresionantes colecciones de arte, armería y pinturas de Velázquez y Goya. Nuestro guía en español te llevará por sus salones más espectaculares.",
            price: 145.00,
            originalPrice: 175.00,
            rating: 9.2,
            reviewCount: 18500,
            travelerCount: 650000,
            categoryId: "guided",
            destinationId: "dest-003",
            imageURLs: [
                "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800&q=80",
                "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80"
            ],
            durationMinutes: 120,
            language: "Español",
            cancellationDays: 5,
            isFree: false,
            meetingPoint: "Plaza de la Armería, frente al Palacio Real, Madrid",
            includes: [
                "Guía en español",
                "Entrada al Palacio Real",
                "Entrada a los Jardines de Sabatini"
            ]
        ),
        // BARCELONA
        ActivityDTO(
            id: "act-007",
            title: "Tour por la Sagrada Família con acceso sin colas",
            descriptionText: "Visita la Sagrada Família, la obra maestra inacabada de Antoni Gaudí, con entrada sin colas. Descubre la arquitectura única de este templo expiatorio: la fachada del Nacimiento, la fachada de la Pasión y las torres que se alzan hacia el cielo. Aprenderás sobre los simbolismos y la visión de Gaudí para su gran obra de vida.",
            price: 198.50,
            originalPrice: nil,
            rating: 9.5,
            reviewCount: 41200,
            travelerCount: 1890000,
            categoryId: "tickets",
            destinationId: "dest-004",
            imageURLs: [
                "https://images.unsplash.com/photo-1583422409516-2895a77efbed?w=800&q=80",
                "https://images.unsplash.com/photo-1558642891-54be180ea339?w=800&q=80"
            ],
            durationMinutes: 90,
            language: "Español",
            cancellationDays: 3,
            isFree: false,
            meetingPoint: "Entrada principal Sagrada Família, Carrer de Mallorca 401, Barcelona",
            includes: [
                "Entrada sin colas a la Sagrada Família",
                "Acceso a las torres (sujeto a disponibilidad)",
                "Audioguía en español"
            ]
        ),
        ActivityDTO(
            id: "act-008",
            title: "Free tour por Barcelona",
            descriptionText: "Descubre Barcelona con este free tour imprescindible. Visitaremos el Barrio Gótico, las Ramblas, el Mercado de la Boqueria, la Catedral de Barcelona, el barrio de la Ribera y el Barrio El Born. ¡La mejor forma de conocer la Ciudad Condal en sus primeras horas!",
            price: 0,
            originalPrice: nil,
            rating: 9.0,
            reviewCount: 22100,
            travelerCount: 780000,
            categoryId: "free",
            destinationId: "dest-004",
            imageURLs: [
                "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800&q=80"
            ],
            durationMinutes: 150,
            language: "Español",
            cancellationDays: 0,
            isFree: true,
            meetingPoint: "Fuente de los Canaletes, Las Ramblas, Barcelona",
            includes: ["Guía voluntario en español"]
        ),
        // LONDON
        ActivityDTO(
            id: "act-009",
            title: "Tour por el Tower Bridge con entrada incluida",
            descriptionText: "Descubre los secretos del icónico Tower Bridge con una visita guiada que incluye acceso a las pasarelas acristaladas sobre el Támesis. Nuestro guía en español te contará la historia de este puente victoriano construido en 1894 y te llevará a los fascinantes mecanismos de elevación del puente.",
            price: 165.00,
            originalPrice: 195.00,
            rating: 8.9,
            reviewCount: 12400,
            travelerCount: 534000,
            categoryId: "tickets",
            destinationId: "dest-005",
            imageURLs: [
                "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&q=80",
                "https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=800&q=80"
            ],
            durationMinutes: 90,
            language: "Español",
            cancellationDays: 3,
            isFree: false,
            meetingPoint: "Tower Bridge Road, junto a la puerta sur del Tower Bridge, Londres",
            includes: [
                "Guía en español",
                "Entrada al Tower Bridge",
                "Acceso a las pasarelas de cristal sobre el Támesis",
                "Visita a la sala de máquinas"
            ]
        ),
        // AMSTERDAM
        ActivityDTO(
            id: "act-010",
            title: "Excursión a Volendam, Marken y Zaanse Schans",
            descriptionText: "En esta excursión desde Ámsterdam visitaremos la Holanda más rural: desde los molinos de Zaanse Schans hasta los bonitos pueblos de Edam, Volendam y Marken. Veremos cómo se fabrica el queso tradicional holandés, visitaremos una fábrica de zuecos y disfrutaremos del paisaje de molinos de viento.",
            price: 206.71,
            originalPrice: nil,
            rating: 9.2,
            reviewCount: 27042,
            travelerCount: 678000,
            categoryId: "excursions",
            destinationId: "dest-006",
            imageURLs: [
                "https://images.unsplash.com/photo-1534351590666-13e3e96b5017?w=800&q=80"
            ],
            durationMinutes: 480,
            language: "Español",
            cancellationDays: 5,
            isFree: false,
            meetingPoint: "Damrak 26, frente a la Central Station, Ámsterdam",
            includes: [
                "Guía en español",
                "Transporte en autobús de lujo",
                "Visita a fábrica de queso tradicional",
                "Demostración de fabricación de zuecos"
            ]
        ),
        // BUDAPEST
        ActivityDTO(
            id: "act-011",
            title: "Crucero nocturno por Budapest",
            descriptionText: "El Puente de las Cadenas, el Parlamento iluminado, el Castillo de Buda... En este crucero nocturno por Budapest con audioguía y una bebida incluida, veréis la magnífica iluminación de la ciudad desde el Danubio. Es uno de los espectáculos más bellos que ofrece Europa de noche.",
            price: 105.46,
            originalPrice: nil,
            rating: 8.7,
            reviewCount: 15913,
            travelerCount: 456000,
            categoryId: "boat",
            destinationId: "dest-007",
            imageURLs: [
                "https://images.unsplash.com/photo-1555442069-c0867ee30db6?w=800&q=80"
            ],
            durationMinutes: 90,
            language: "Español",
            cancellationDays: 2,
            isFree: false,
            meetingPoint: "Muelle Vigadó (Vigadó tér 3), Budapest",
            includes: [
                "Crucero nocturno de 1.5h",
                "Una bebida incluida",
                "Audioguía en español"
            ]
        ),
        // TOKYO
        ActivityDTO(
            id: "act-012",
            title: "Tour por Shinjuku y Akihabara en Tokio",
            descriptionText: "Descubre los contrastes de Tokio en este tour por Shinjuku y Akihabara. Visitaremos el Santuario Meiji, el Parque Yoyogi, el bullicioso barrio de Harajuku, los neones de Shinjuku y el fascinante barrio electrónico de Akihabara. Una jornada para entender los contrastes del Japón contemporáneo y tradicional.",
            price: 250.00,
            originalPrice: 280.00,
            rating: 9.4,
            reviewCount: 8900,
            travelerCount: 234000,
            categoryId: "guided",
            destinationId: "dest-008",
            imageURLs: [
                "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80",
                "https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=800&q=80"
            ],
            durationMinutes: 300,
            language: "Español",
            cancellationDays: 5,
            isFree: false,
            meetingPoint: "Salida Este de la estación de Shinjuku (JR), Tokio",
            includes: [
                "Guía en español",
                "Tarjeta de transporte para metro incluida",
                "Entrada al Santuario Meiji"
            ]
        )
    ]
}
