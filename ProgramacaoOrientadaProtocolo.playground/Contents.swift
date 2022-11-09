import UIKit

// Protocolo e conformidade
/*
 Vamos definir dois protocolos, Bird para representar um objeto real do tipo pássaro e outro Flyable para representar objetos voadores.
 */
//protocol Bird {
//    var name: String { get }
//    var canFly: Bool { get }
//}
protocol Flyable {
    var maximumSpeed: Double { get }
}

/*
 Vamos definir tipos que estejam em conformidade com o protocolo
 Vamos criar uma struct para passáros que voa, um Papagaio
 */
struct Parrot: Bird, Flyable {
    let name: String
    let amplitude: Double
    let frequency: Double
    let canFly = true
    
    var maximumSpeed: Double {
        3 * amplitude * frequency
    }
}
let parrot = Parrot(name: "Papagaio", amplitude: 12.0, frequency: 5.0)
print("O \(parrot.name) voa na velocidade máxima de \(parrot.maximumSpeed) km/h.")

/*
 Vamos criar mais uma struct, um pinguim, pássaro que não voa.
 */
struct Penguin: Bird {
    let name: String
    let canFly = false
}
let penguin = Penguin(name: "Pinguim")
print("\(penguin.name) é um pássaro que voa? \(penguin.canFly ? "Sim!" : "Não!")")

// Extensão de Protocolo
/*
 Vamos criar uma extensão para definir seu comportamento default
 canFly será definida automaticamente sempre que o tipo estiver em conformidade com Flyable, evitando código redundante
 */
extension Bird {
    var canFly: Bool { self is Flyable }
}

/*
 Dessa forma não precisamos mais declarar canFly, isso porque a extensão do protocolo agora lida com esse requisito.
 Vamos criar mais duas structs que define uma Pombo que voa e uma Avestruz que não voa
 */
struct Dove: Bird, Flyable {
    let name: String
    let amplitude: Double
    let frequency: Double
    
    var maximumSpeed: Double {
        3 * amplitude * frequency
    }
}
struct Ostrich: Bird  {
    let name: String
}
let dove = Dove(name: "Pombo", amplitude: 14.0, frequency: 3.0)
print("\(dove.name) voa? \(dove.canFly ? "Sim!" : "Não!"). Em qual velocidade máxima: \(dove.maximumSpeed) km/h.")
let ostrich = Ostrich(name: "Avestruz")
print("\(ostrich.name) é um pássaro que voa? \(ostrich.canFly ? "Sim!" : "Não!")")

/*
 Não somente classes e structs podem estar em conformidades com protocolos, enuns também
 Vamos criar uma enum que represente uma Andorinha
 */
enum Swallow: Bird, Flyable {
    case african
    case european
    case unknown
    
    var name: String {
        switch self {
        case .african:
            return "Andorinha Africana"
        case .european:
            return "Andorinha Europeia"
        case .unknown:
            return "Andorinha"
        }
    }
    
    var maximumSpeed: Double {
        switch self {
        case .african:
            return 10.0
        case .european:
            return 9.9
        case .unknown:
            fatalError("Sem velocidade máxima")
        }
    }
}
/*
 Por estar em conformidade, Swallow também usa a implementação padrão para canFly
 */

// Comportamento padrão
/*
 Noso enum Swallow recebeu automaticamente uma implementação para canFly por estar em conformidade com o protocolo Flyable.
 No entanto, se desejarmos retornar false para canFly ao usar .unknown podemos substituir a implementação padrão.
 */
extension Swallow {
    
    var canFly: Bool {
        self != .unknown
    }
}

/*
 Agora só .african e .european vai retornar true para canFly.
 */
Swallow.unknown.canFly            // false
Swallow.african.canFly            // true
Penguin(name: "Pinguim").canFly  // false

// Extensões condicionais
/*
 Também podemos adequar nossos próprios protocolos a outros protocolos, como por exemplo da biblioteca padrão do Swift, e definir comportamentos padrão.
 Vamos voltar ao protocolo Bird e substituir sua declaração adicionando o protocolo CustomStringConvertible
 */
protocol Bird: CustomStringConvertible {
    var name: String { get }
    var canFly: Bool { get }
}

extension CustomStringConvertible where Self: Bird {
    var description: String {
        canFly ? "Pode voar" : "Não pode voar"
    }
}

/*
 Em conformidade com CustomStringConvertible significa que precisamos ter uma propriedade description para ser convertido automaticamente em uma String quando necessário.
 Em vez de adicionar essa propriedade a cada tipo atual e futuro, você definiu uma extensão de protocolo que associará CustomStringConvertible apenas a tipos de Bird.
 */
Swallow.african

/*
 Até agora definimos vários tipos que estão em conformidade com o Bird.
 Agora vamos adicionar algo completamente diferente.
 Vamos criar uma classe que não tem nada a ver com pássaros ou voar.
 Só queremos correr de moto.
 */
class Motorcycle {
    var name: String
    var speed: Double
    
    init(name: String) {
        self.name = name
        speed = 200.0
    }
    
}

/*
 Para unificar esses tipos díspares, vamos precisar de um protocolo comum para corridas.
 Podemos gerenciar isso sem nem mesmo tocar nas definições do modelo original, graças a modelagem retroativa.
 */

// 1
protocol Racer {
    var speed: Double { get }  // velocidade é a única coisa com que os pilotos se importam
}
/*
 1 - Definimos o protocolo Racer.
 Este protocolo define qualquer coisa que possa correr.
 */

// 2
extension Parrot: Racer {
    
    var speed: Double {
        maximumSpeed
    }
}
extension Penguin: Racer {
    
    var speed: Double {
        42  // velocidade total
    }
}
extension Swallow: Racer {
    
    var speed: Double {
        canFly ? maximumSpeed : 0.0
    }
}
extension Motorcycle: Racer {}
/*
 2 - Deixamos tudo em conformidade com Racer.
 Alguns tipos, como Motorcycle, obedecem trivialmente.
 Outros, como Swallow, precisam de um pouco mais de lógica.
 De qualquer forma, quando terminar, você terá vários tipos em conformidade com Racer.
 */

// 3
let racers: [Racer] = [
    Swallow.african,
    Swallow.european,
    Swallow.unknown,
    Penguin(name: "Pinguim"),
    Parrot(name: "Papagaio", amplitude: 12.0, frequency: 5.0),
    Motorcycle(name: "Augusto")
]
/*
 Com todos os tipos na linha inicial, criamos um Array do tipo Racer que contém uma instância de cada um dos tipos que criamos.
 */

/*
 Vamos criar uma função que determina a velocidade máxima dos pilotos.
 */
func topSpeed(of racers: [Racer]) -> Double {
    racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}
print("Velocidade máxima dos pilotos \(topSpeed(of: racers))") // 200.0

/*
 Vamos criar uma extension para para determinar a velocidade máxima
 */
extension Sequence where Iterator.Element == Racer {
    
    func topSpeed() -> Double {
        self.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
    }
}
print("Velocidade máxima dos pilotos \(racers.topSpeed())") // 200.0
print("Velocidade máxima entre 3 primeiros pilotos \(racers[1...3].topSpeed())") // 42

/*
 Funções mutantes
 Até agora, todos os exemplos que implementamos demonstraram como adicionar funcionalidade.
 Mas e se quiser que um protocolo defina algo que mude um aspecto do seu objeto?
 Podemos fazer isso usando métodos mutantes em nosso protocolo.
 */
protocol Cheat {
    mutating func boost(_ power: Double)
}

/*
 Definimos um protocolo que dá ao nosso tipo a capacidade impulsionar.
 Vamos criar uma struct que define um joguinho de Swift
 Em seguida, vamnos criar uma extensão para nossa struct e que esteja de acordo Cheat:
 */
struct SwiftBird: Bird, Flyable {
    var name: String { "Swift \(version)" }
    let canFly = true
    let version: Double
    private var speedFactor = 1000.0
    
    init(version: Double) {
        self.version = version
    }
    
    var maximumSpeed: Double {
        version * speedFactor
    }
}
extension SwiftBird: Cheat {
    
    mutating func boost(_ power: Double) {
        speedFactor += power
    }
}
var swiftBird = SwiftBird(version: 5.0)
print("Velocidade igual = \(swiftBird.maximumSpeed)") // 5000
swiftBird.boost(3.0)
print("Velocidade igual = \(swiftBird.maximumSpeed)") // 5015
swiftBird.boost(3.0)
print("Velocidade igual = \(swiftBird.maximumSpeed)") // 5030
