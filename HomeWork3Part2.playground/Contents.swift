import UIKit

var greeting = "Hello, playground"
import Foundation

// Визначення типів
enum Currency: String {
    case uah = "UAH"
    case usd = "USD"
    case eur = "EUR"
}

enum Discount {
    case none
    case vip
}

class Product {
    var name: String
    var price: Double

    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }

    func textDescription() -> String {
        return "Назва: \(name), Ціна: \(String(format: "%.2f", price)) UAH"
    }
}

class Cart {
    var products: [Product] = []
    var discount: Discount = .none

    func clear() {
        products.removeAll()
    }

    func discountPercentValue() -> Double {
        switch discount {
        case .none: return 0
        case .vip: return 10
        }
    }

    func totalPrice() -> Double {
        return products.reduce(0) { $0 + $1.price }
    }

    func totalPriceWithDiscount() -> Double {
        let discountMultiplier = (100 - discountPercentValue()) / 100
        return totalPrice() * discountMultiplier
    }
}

class Screen {
    func printCheck(cart: Cart) {
        if cart.products.isEmpty {
            print("Кошик пустий. Для оформлення замовлення додайте хоча б один товар")
            return
        }

        var resultStringToPrint = ""
        let firstLine = "--------------- ФІСКАЛЬНИЙ ЧЕК ----------------"
        resultStringToPrint += firstLine

        let separatorLine = "\n-----------------------------------------------"

        for index in 0..<cart.products.count {
            let product = cart.products[index]
            resultStringToPrint += "\n\(index + 1)\n"
            resultStringToPrint += product.textDescription()
        }

        resultStringToPrint += separatorLine

        resultStringToPrint += "\nTotal price: \(String(format: "%.2f", cart.totalPrice())) UAH"
        resultStringToPrint += "\nDiscount: \(cart.discountPercentValue())%"

        resultStringToPrint += separatorLine

        resultStringToPrint += "\nTotal price with Discount:\n\(String(format: "%.2f", cart.totalPriceWithDiscount())) UAH"

        resultStringToPrint += separatorLine + separatorLine

        print(resultStringToPrint)
    }

    func printCart(cart: Cart, currency: Currency) {
        let usd = 36.57
        let eur = 40.32

        var selectedCurrencyValue = 1.0
        switch currency {
        case .usd:
            selectedCurrencyValue = usd
        case .eur:
            selectedCurrencyValue = eur
        case .uah:
            selectedCurrencyValue = 1.0
        }

        var resultStringToPrint = ""
        resultStringToPrint += "------------------------ Обрана валюта: \(currency.rawValue) ---------------------------"

        for index in 0..<cart.products.count {
            let product = cart.products[index]
            let convertedPrice = product.price / selectedCurrencyValue
            resultStringToPrint += "\n\(index + 1) Назва продукту: \(product.name), Ціна: \(currency.rawValue) \(String(format: "%.2f", convertedPrice))"
        }

        resultStringToPrint += "\n---------------------------------------------------------------------"
        print(resultStringToPrint)
    }
}

class ResponseFromServer {
    var sourceProducts: [(String, Double)] = [
        ("Сhocolate", 30.5),
        ("Bread", 15.2),
        ("Cheese", 100.0)
    ]

    func get3Products() -> [(String, Double)] {
        return Array(sourceProducts.prefix(3))
    }
}

class DataMapper {
    func products(from tuples: [(String, Double)]) -> [Product] {
        return tuples.map { Product(name: $0.0, price: $0.1) }
    }
}

// Основна програма
print("SCENARIO 1:\n")

let responseFromServer = ResponseFromServer()
let receivedProducts = responseFromServer.sourceProducts
let dataMapper = DataMapper()

let cart = Cart()
cart.products = dataMapper.products(from: receivedProducts)
cart.discount = .vip

let screen = Screen()
screen.printCheck(cart: cart)

print("\nSCENARIO 2:\n")

cart.products = dataMapper.products(from: responseFromServer.get3Products())
cart.clear()
screen.printCheck(cart: cart)

print("\nSCENARIO 3:\n")

cart.products = dataMapper.products(from: responseFromServer.sourceProducts)

screen.printCart(cart: cart, currency: .uah)
screen.printCart(cart: cart, currency: .usd)
screen.printCart(cart: cart, currency: .eur)


