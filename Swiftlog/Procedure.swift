import VPIAssistant

typealias PLIInt32 = PLI_INT32

public enum Value: Int
{
    case binaryString = 1
    case octalString = 2
    case decimalString = 3
    case hexadecimalString = 4
    case scalar = 5
    case integer = 6
    case real = 7
    case string = 8
    case vector = 9
    case strength = 10
    case time = 11
    case objectType = 12
    case suppressed = 13
}

public enum ObjectType: Int
{
    case constant = 7
    case function = 20
    case integer = 25
    case iterator = 27
    case memory = 29
    case memoryWord = 30
    case modulePath = 31
    case module = 32
    case namedBegin = 33
    case namedEvent = 34
    case namedFork = 35
    case net = 36
    case parameter = 41
    case partSelect = 42
    case pathTerm = 43
    case real = 47
    case register = 48
    case functionCall = 56
    case taskCall = 57
    case task = 59
    case time = 63
    case netArray = 114
    case index = 78
    case leftRange = 79
    case parent = 81
    case rightRange = 83
    case scope = 84
    case anyCall = 85
    case argument = 89
    case internalScope = 92
    case modPathIn = 95
    case modPathOut = 96
    case variables = 100
    case expression = 102

    case any = 777

    case callback = 1000
}

public struct Object
{
    private var handle: vpiHandle
    
    public var type: ObjectType? {
        return ObjectType(rawValue: Int(vpi_get(vpiType, handle)))
    }

    public var asInt: Int32 {
        var value = s_vpi_value()
        value.format = vpiIntVal
        vpi_get_value(handle, &value)
        return value.value.integer
    }

    public func update(_ val: Int32) {
        var value = s_vpi_value()
        value.format = vpiIntVal
        value.value.integer = val
        vpi_put_value(handle, &value, nil, vpiNoDelay)
    }

    init(handle: vpiHandle)
    {
        self.handle = handle
    }
}

public enum ProcedureType: Int
{
    case task = 1
    case function = 2
}

func compiletf(user_data: UnsafeMutablePointer<Int8>?) -> PLIInt32
{
    if let data = user_data, let procedure = Procedure.dictionary[String(cString: data)]
    {
        return procedure.compile()
    }
    print("Fatal Error: Failed to get name of last function called.")
    Control.finish()
    return 0
}

func calltf(user_data: UnsafeMutablePointer<Int8>?) -> PLIInt32
{
    if let data = user_data, let procedure = Procedure.dictionary[String(cString: data)]
    {
        return procedure.call()
    }
    print("Fatal Error: Failed to get name of last function called.")
    Control.finish()
    return 0
}

public class Procedure
{
    public static var dictionary: [String: Procedure] = [:]
    private var store: s_vpi_systf_data
    private var name: String
    private var cNameSize: Int
    private var cNamePointer: UnsafeMutablePointer<UInt8>
    private var type: ProcedureType
    private var arguments: [ObjectType]
    private var registered: Bool
    private var validate: ((_: inout [Object]) -> (Bool))?
    private var execute: (_: inout [Object]) -> (Bool)
    
    public init(name: String, type: ProcedureType = .task, arguments: [ObjectType] = [], validationClosure: @escaping (_: inout [Object]) -> (Bool) = { _ in return true }, executionClosure: @escaping (_: inout [Object]) -> (Bool), register: Bool = false)
    {
        self.name = name
        self.type = type
        self.arguments = arguments
        self.validate = validationClosure
        self.execute = executionClosure
        self.store = s_vpi_systf_data()

        let pointers = self.name.cPointer
        self.cNameSize = pointers.elementCount
        self.cNamePointer = pointers.mutable
        self.store.tfname = pointers.cLiteral
        self.store.user_data = pointers.cMutable

        self.store.type = PLIInt32(self.type.rawValue)
        self.store.compiletf = compiletf
        self.store.calltf = calltf

        if (register)
        {            
            vpi_register_systf(&self.store)
            self.registered = true
            Procedure.dictionary[name] = self
        }
        else
        {
            self.registered = false
        }
    }

    public func register()
    {
        if (!registered)
        {            
            vpi_register_systf(&self.store)
            self.registered = true
            Procedure.dictionary[name] = self
        }
    }

    func compile() -> PLIInt32
    {
        guard let handle = vpi_handle(vpiSysTfCall, nil)
        else
        {
            print("Fatal Error: $\(self.name) failed to obtain handle. The simulation will abort.")
            Control.finish()
            return 0
        }

        if arguments.count > 0
        {        
            guard let iterator = vpi_iterate(vpiArgument, handle)
            else
            {
                print("\(self.name) requires \(arguments.count) argument(s). The simulation will abort.")
                Control.finish()
                return 0
            }

            var count = 0
            while let argument = vpi_scan(iterator)
            {
                let type = vpi_get(vpiType, argument)

                if Int(type) != self.arguments[count].rawValue && self.arguments[count] != .any
                {
                    print("\(self.name), argument \(count): Invalid argument type.")
                    Control.finish()
                    return 0
                }

                count += 1
            }

            if count != arguments.count
            {
                print("\(self.name) requires \(arguments.count) argument(s) (\(count) provided). The simulation will abort.")
                Control.finish()
            }

            //TODO: Also make user-validation available

        }

        return 0
    }

    func call() -> PLIInt32
    {        
        var array: [Object] = []

        if (arguments.count > 0) {
            let handle = vpi_handle(vpiSysTfCall, nil)!
            let iterator = vpi_iterate(vpiArgument, handle)!

            for _ in 0..<arguments.count {
                array.append(Object(handle: vpi_scan(iterator)!))
            }
        }
        return execute(&array) ? 0 : -1
    }

    deinit
    {
        self.cNamePointer.deallocate(capacity: self.cNameSize)
    }

}