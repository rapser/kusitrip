import Foundation

struct Category: Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String

    static let all        = Category(id: "all",        name: "Todos",             icon: "square.grid.2x2")
    static let guided     = Category(id: "guided",     name: "Visitas guiadas",   icon: "person.2")
    static let excursions = Category(id: "excursions", name: "Excursiones",       icon: "bus")
    static let tickets    = Category(id: "tickets",    name: "Entradas",          icon: "ticket")
    static let gastronomy = Category(id: "gastronomy", name: "Gastronomía",       icon: "fork.knife")
    static let transport  = Category(id: "transport",  name: "Traslados",         icon: "car")
    static let boat       = Category(id: "boat",       name: "Paseos en barco",   icon: "ferry")
    static let free       = Category(id: "free",       name: "Free Tours",        icon: "star.circle")
}
